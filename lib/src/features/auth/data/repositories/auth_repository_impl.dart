import 'package:bloc_api_integration/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bloc_api_integration/src/features/auth/data/models/user_model.dart';
import 'package:bloc_api_integration/src/features/auth/domain/entities/user_entity.dart';
import 'package:bloc_api_integration/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserModel user = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signInWithEmailPassword
    throw UnimplementedError();
  }
}
