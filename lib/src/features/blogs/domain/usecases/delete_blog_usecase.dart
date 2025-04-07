import 'package:bloc_api_integration/src/core/use_cases/use_case.dart';
import 'package:bloc_api_integration/src/features/blogs/domain/repositories/blog_repository.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlogUsecase implements UseCase<void, DeleteBlogParams> {
  final BlogRepository blogRepository;
  DeleteBlogUsecase(this.blogRepository);

  @override
  Future<Either<Failure, void>> call(DeleteBlogParams params) async {
    return await blogRepository.deleteBlog(blogId: params.blogId);
  }
}

class DeleteBlogParams {
  final String blogId;
  DeleteBlogParams({required this.blogId});
}
