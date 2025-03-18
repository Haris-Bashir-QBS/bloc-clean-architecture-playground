import 'dart:async';

import 'package:bloc_api_integration/src/core/use_cases/use_case.dart';
import 'package:bloc_api_integration/src/features/auth/domain/entities/user_entity.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:fpdart/fpdart.dart';
import '../repositories/auth_repository.dart';

class CurrentUserUsecase extends UseCase<UserEntity, NoParams> {
  final AuthRepository authRepository;

  CurrentUserUsecase(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(params) async {
    return await authRepository.currentUser();
  }
}
