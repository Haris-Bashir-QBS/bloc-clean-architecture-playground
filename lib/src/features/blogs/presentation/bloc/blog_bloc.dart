import 'package:bloc_api_integration/src/core/use_cases/use_case.dart';
import 'package:bloc_api_integration/src/features/blogs/domain/usecases/get_all_blogs_usecase.dart';
import 'package:bloc_api_integration/src/features/blogs/domain/usecases/upload_blog_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../network/api_exceptions.dart';
import '../../domain/entities/blog_entity.dart';
import 'blog_event.dart';
import 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlogUseCase _uploadBlog;
  final GetAllBlogsUseCase _getAllBlogs;

  BlogBloc({
    required UploadBlogUseCase uploadBlog,
    required GetAllBlogsUseCase getAllBlogs,
  }) : _uploadBlog = uploadBlog,
       _getAllBlogs = getAllBlogs,
       super(BlogInitial()) {
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogFetchAllBlogsEvent>(_onFetchAllBlogs);
  }

  /// =================== Get all blogs =============

  void _onFetchAllBlogs(
    BlogFetchAllBlogsEvent event,
    Emitter<BlogState> emit,
  ) async {
    emit(BlogLoading());
    Either<Failure, List<BlogEntity>> blogsOrFailure = await _getAllBlogs(
      NoParams(),
    );
    blogsOrFailure.fold(
      (Failure failure) => emit(BlogFailure(failure.message)),
      (List<BlogEntity> blogs) => emit(BlogsFetchSuccess(blogs: blogs)),
    );
  }

  /// ================== Upload blog =============

  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());

    Either<Failure, BlogEntity> blogOrFailure = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    blogOrFailure.fold(
      (Failure failure) => emit(BlogFailure(failure.message)),
      (BlogEntity blog) => emit(BlogUploadSuccess()),
    );
  }
}
