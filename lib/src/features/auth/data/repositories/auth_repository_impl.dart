import 'package:bloc_api_integration/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:bloc_api_integration/src/features/auth/data/models/user_model.dart';
import 'package:bloc_api_integration/src/features/auth/domain/entities/user_entity.dart';
import 'package:bloc_api_integration/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:bloc_api_integration/src/services/connectivity_service.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> currentUser() async {
    try {
      if (!await (ConnectivityService.instance.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure(message: 'User not logged in!'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure(message: 'User not logged in!'));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

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
  Future<Either<Failure, UserEntity>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserModel user = await remoteDataSource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      bool isSignOut = await remoteDataSource.signOut();
      return right(isSignOut);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
