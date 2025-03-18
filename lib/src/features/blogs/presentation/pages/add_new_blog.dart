import 'dart:io';
import 'package:bloc_api_integration/src/core/theme/app_palette.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/bloc/blog_state.dart';
import 'package:bloc_api_integration/src/features/blogs/presentation/widgets/blog_editor.dart';
import 'package:bloc_api_integration/src/widgets/snackbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/cubits/app_user_cubit.dart';
import '../../../../core/common/cubits/app_user_state.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/image_picker.dart';
import '../bloc/blog_event.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, content: state.error);
          } else if (state is BlogUploadSuccess) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null ? _imageShow() : _imageSelector(),
                    const SizedBox(height: 20),
                    _topicsHorizontalListView(),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog title',
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog content',
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

  Widget _imageShow() {
    return GestureDetector(
      onTap: selectImage,
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(image!, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _imageSelector() {
    return GestureDetector(
      onTap: () {
        selectImage();
      },
      child: DottedBorder(
        color: AppPallete.borderColor,
        dashPattern: const [10, 4],
        radius: const Radius.circular(10),
        borderType: BorderType.RRect,
        strokeCap: StrokeCap.round,
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_open, size: 40),
              SizedBox(height: 15),
              Text('Select your image', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topicsHorizontalListView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            Constants.topics
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        if (selectedTopics.contains(e)) {
                          selectedTopics.remove(e);
                        } else {
                          selectedTopics.add(e);
                        }
                        setState(() {});
                      },
                      child: Chip(
                        label: Text(e),
                        color:
                            selectedTopics.contains(e)
                                ? const WidgetStatePropertyAll(
                                  AppPallete.gradient1,
                                )
                                : null,
                        side:
                            selectedTopics.contains(e)
                                ? null
                                : const BorderSide(
                                  color: AppPallete.borderColor,
                                ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
        BlogUploadEvent(
          posterId: posterId,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          image: image!,
          topics: selectedTopics,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }
}
