import 'package:bloc_api_integration/src/core/use_cases/use_case.dart';
import 'package:bloc_api_integration/src/features/blogs/domain/usecases/delete_blog_usecase.dart';
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
  final DeleteBlogUsecase _deleteBlog;

  BlogBloc({
    required UploadBlogUseCase uploadBlog,
    required GetAllBlogsUseCase getAllBlogs,
    required DeleteBlogUsecase deleteBlog,
  }) : _uploadBlog = uploadBlog,
       _getAllBlogs = getAllBlogs,
       _deleteBlog = deleteBlog,

       super(BlogInitial()) {
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogFetchAllBlogsEvent>(_onFetchAllBlogs);
    on<DeleteBlogEvent>(_onDeleteBlog);
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
      BlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    blogOrFailure.fold(
      (Failure failure) => emit(BlogFailure(failure.message)),
      (BlogEntity blog) {
        emit(BlogUploadSuccess());
        add(BlogFetchAllBlogsEvent());
      },
    );
  }

  // =================== Delete blog =============
  void _onDeleteBlog(DeleteBlogEvent event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    Either<Failure, void> deleteOrFailure = await _deleteBlog(
      DeleteBlogParams(blogId: event.blogId),
    );

    deleteOrFailure.fold(
      (Failure failure) => emit(BlogFailure(failure.message)),
      (void _) {
        emit(BlogDeleteSuccess());
        add(BlogFetchAllBlogsEvent());
      },
    );
  }
}
