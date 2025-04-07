import 'dart:io';

import 'package:bloc_api_integration/src/features/blogs/domain/entities/blog_entity.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/use_cases/use_case.dart';
import '../repositories/blog_repository.dart';

class UploadBlogUseCase implements UseCase<BlogEntity, BlogParams> {
  final BlogRepository blogRepository;
  UploadBlogUseCase(this.blogRepository);

  @override
  Future<Either<Failure, BlogEntity>> call(BlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class BlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
