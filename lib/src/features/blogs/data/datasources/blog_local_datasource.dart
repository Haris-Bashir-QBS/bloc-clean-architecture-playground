import 'dart:io';

import 'package:bloc_api_integration/src/features/blogs/data/models/blog_model.dart';

abstract class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}
