import 'package:bloc_api_integration/src/features/blogs/data/models/blog_model.dart';
import 'package:hive/hive.dart';
import 'blog_local_datasource.dart';

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box hiveBox;
  BlogLocalDataSourceImpl({required this.hiveBox});

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    hiveBox.read(() {
      for (int i = 0; i < hiveBox.length; i++) {
        blogs.add(BlogModel.fromJson(hiveBox.get(i.toString())));
      }
    });

    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    hiveBox.clear();
    hiveBox.write(() {
      for (int i = 0; i < blogs.length; i++) {
        hiveBox.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
