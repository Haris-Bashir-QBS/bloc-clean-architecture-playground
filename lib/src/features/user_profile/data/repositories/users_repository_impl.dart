
import 'package:bloc_api_integration/src/features/user_profile/domain/entities/user_listing.dart';
import 'package:bloc_api_integration/src/features/user_profile/domain/repositories/user_repository.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:bloc_api_integration/src/network/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository  {
  final UserRemoteDataSource userRemoteDataSource;
  UserRepositoryImpl(this.userRemoteDataSource);

  @override
  Future<Either<Failure,UserEntity>> fetchUser(String id) async {
    try {
      final user = await userRemoteDataSource.fetchUser(id);
      return right(user);
    } on Failure catch (e) {
      return left(e);
    } on DioException catch (e) {
      return left(ApiErrorHandler.handleError(e));
    } catch (e) {
      return left(UnknownException(RequestOptions(path: "/user")));
    }
  }

  @override
  Future<Either<Failure,UserListingEntity >> fetchUsers(int page)async {
    try {
      final user = await userRemoteDataSource.fetchUsers(page);
      return right(user);
    } on Failure catch (e) {
      return left(e);
    } on DioException catch (e) {
      return left(ApiErrorHandler.handleError(e));
    } catch (e) {
      return left(UnknownException(RequestOptions(path: "/user")));
    }
  }
}
