import 'package:bloc_api_integration/src/core/router/app_routes.dart';
import 'package:bloc_api_integration/src/core/theme/app_palette.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/bloc/blog_event.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/bloc/blog_state.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/widgets/blog-card.dart';
import 'package:bloc_api_integration/src/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchAllBlogs();
  }

  void fetchAllBlogs() {
    context.read<BlogBloc>().add(BlogFetchAllBlogsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog App'), actions: []),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, content: state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BlogsFetchSuccess) {
            return _blogsListView(state);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPallete.gradient1,
        onPressed: () {
          context.pushNamed(AppRoutes.addNewBlog);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _blogsListView(BlogsFetchSuccess state) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchAllBlogs();
      },
      child: ListView.builder(
        itemCount: state.blogs.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final blog = state.blogs[index];
          return BlogCard(
            blog: blog,
            color: index % 2 == 0 ? AppPallete.gradient1 : AppPallete.gradient2,
            onTap: () {
              context.pushNamed(AppRoutes.blogViewer, extra: blog);
            },
          );
        },
      ),
    );
  }
}
