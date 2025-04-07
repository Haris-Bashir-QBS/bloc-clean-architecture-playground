import 'package:bloc_api_integration/src/core/theme/app_palette.dart';
import 'package:bloc_api_integration/src/core/utils/format_date.dart';
import 'package:bloc_api_integration/src/features/blogs/domain/entities/blog_entity.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/bloc/blog_state.dart';
import 'package:bloc_api_integration/src/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/calculate-reading_time.dart';
import '../../../../widgets/snackbar.dart';
import '../bloc/blog_event.dart';

class BlogViewerPage extends StatelessWidget {
  final BlogEntity blog;

  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _deleteDialog(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogDeleteSuccess) {
            showSnackBar(context, content: 'Blog deleted successfully');
            Navigator.pop(context);
          }
          if (state is BlogFailure) {
            showSnackBar(context, content: state.error);
          }
        },
        builder: (context, state) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'By ${blog.posterName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppPallete.greyColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _headerImageWidget(),
                    const SizedBox(height: 20),
                    Text(
                      blog.content,
                      style: const TextStyle(fontSize: 16, height: 2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _headerImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Image.network(
          blog.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child; // Image fully loaded
            }
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }

  void _deleteDialog(BuildContext context) {
    return showConfirmationDialog(
      context: context,
      title: "Delete Blog",
      content: "Are you sure you want to delete this blog?",
      confirmText: "Delete",
      cancelText: "Cancel",
      onConfirm: () {
        context.read<BlogBloc>().add(DeleteBlogEvent(blogId: blog.id));
      },
    );
  }
}
