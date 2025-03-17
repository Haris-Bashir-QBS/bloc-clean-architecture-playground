import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> signInWithEmailPassword({
    required String email,
    required String password,
  });
}
