import 'dart:developer';
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
      bool isConnected = await ConnectivityService.instance.isConnected;
      print("internet status is $isConnected");
      if (!isConnected) {
        log("Here it is not connected ${isConnected}");
        return left(NetworkException());
      }
      print("clause 1");
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
      if (!await ConnectivityService.instance.isConnected) {
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

  @override
  Future<Either<Failure, void>> deleteBlog({required String blogId}) async {
    try {
      if (!await ConnectivityService.instance.isConnected) {
        return left(NetworkException());
      }
      await _blogRemoteDataSource.deleteBlog(blogId: blogId);
      return right(null);
    } on ServerException catch (e) {
      return left(ServerException(message: e.message));
    } catch (e) {
      return left(UnknownException(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBlog({required BlogEntity blog}) async {
    try {
      if (!await ConnectivityService.instance.isConnected) {
        return left(NetworkException());
      }

      final blogModel = BlogModel(
        id: blog.id,
        title: blog.title,
        content: blog.content,
        imageUrl: blog.imageUrl,
        posterName: blog.posterName,
        posterId: blog.posterId,
        topics: blog.topics,
        updatedAt: DateTime.now(),
      );

      await _blogRemoteDataSource.updateBlog(blog: blogModel);
      return right(null);
    } on ServerException catch (e) {
      return left(ServerException(message: e.message));
    } catch (e) {
      return left(UnknownException(message: e.toString()));
    }
  }
}
