import 'dart:async';

import 'package:bloc_api_integration/src/core/use_cases/use_case.dart';
import 'package:bloc_api_integration/src/features/auth/domain/entities/user_entity.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:fpdart/fpdart.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase extends UseCase<UserEntity, UserSignupParams> {
  final AuthRepository authRepository;

  SignUpUseCase(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignupParams {
  final String name;
  final String email;
  final String password;

  UserSignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
