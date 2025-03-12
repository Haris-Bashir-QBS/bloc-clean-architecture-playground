import 'dart:developer';

import 'package:bloc_api_integration/src/features/daily_news/data/datasources/remote/news_remote_datasource.dart';
import 'package:bloc_api_integration/src/features/daily_news/domain/entities/article_entity.dart';

import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../network/error_handler.dart';
import '../../domain/repositories/article_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDatasource _newsRemoteDatasource;

  NewsRepositoryImpl(this._newsRemoteDatasource);
  @override
  Future<Either<Failure, List<ArticleEntity>>> getANewsArticles(
    int page,
  ) async {
    try {
      final user = await _newsRemoteDatasource.getNewsArticles(page);
      return right(user);
    } on Failure catch (e) {
      return left(e);
    } on DioException catch (e) {
      return left(ApiErrorHandler.handleError(e));
    } catch (e) {
      log("Hereeeeeee $e");
      return left(UnknownException(RequestOptions(path: "/user")));
    }
  }
}
