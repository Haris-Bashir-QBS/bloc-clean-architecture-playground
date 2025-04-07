import 'dart:io';

import 'package:bloc_api_integration/src/features/blogs/domain/entities/blog_entity.dart';
import 'package:equatable/equatable.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => [];
}

class BlogUploadEvent extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  const BlogUploadEvent({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });

  @override
  List<Object?> get props => [posterId, title, content, image, topics];
}

class BlogFetchAllBlogsEvent extends BlogEvent {
  const BlogFetchAllBlogsEvent();
}

class DeleteBlogEvent extends BlogEvent {
  final String blogId;
  const DeleteBlogEvent({required this.blogId});
}
