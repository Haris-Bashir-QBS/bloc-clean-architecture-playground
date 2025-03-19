import 'package:bloc_api_integration/src/features/blogs/domain/entities/blog_entity.dart';

class BlogState {}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogUploadSuccess extends BlogState {
  BlogUploadSuccess();
}

class BlogsFetchSuccess extends BlogState {
  final List<BlogEntity> blogs;
  BlogsFetchSuccess({required this.blogs});
}

class BlogFailure extends BlogState {
  final String error;
  BlogFailure(this.error);
}
