import 'package:bloc_api_integration/src/features/daily_news/domain/entities/article_entity.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class NewsRepository {
  Future<Either<Failure, List<ArticleEntity>>> getANewsArticles(int page);
}
