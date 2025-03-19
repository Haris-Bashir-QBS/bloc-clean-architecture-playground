import 'dart:io';

import 'package:bloc_api_integration/src/features/blogs/data/models/blog_model.dart';

abstract class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog({required BlogModel blog});
  Future<String> uploadBlogImage({
    required BlogModel blog,
    required File image,
  });
  Future<List<BlogModel>> getAllBlogs();
}
