import 'dart:io';

import 'package:bloc_api_integration/src/features/blogs/domain/entities/blog_entity.dart';

import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:bloc_api_integration/src/services/connectivity_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/blog_repository.dart';
import '../datasources/blog_local_datasource.dart';
import '../datasources/blog_remote_datasource.dart';
import '../models/blog_model.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource _blogRemoteDataSource;
  final BlogLocalDataSource _blogLocalDataSource;

  BlogRepositoryImpl({
    required BlogRemoteDataSource remoteDataSource,
    required BlogLocalDataSource localDataSource,
  }) : _blogRemoteDataSource = remoteDataSource,
       _blogLocalDataSource = localDataSource;

  @override
  Future<Either<Failure, BlogEntity>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await ConnectivityService.isConnected) {
        return left(NetworkException());
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await _blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlog = await _blogRemoteDataSource.uploadBlog(
        blog: blogModel,
      );
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(ServerException(message: e.message));
    } catch (e) {
      return left(UnknownException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BlogEntity>>> getAllBlogs() async {
    try {
      if (!await ConnectivityService.isConnected) {
        final blogs = _blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await _blogRemoteDataSource.getAllBlogs();
      _blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(ServerException(message: e.message));
    } catch (e) {
      return left(UnknownException(message: e.toString()));
    }
  }
}
