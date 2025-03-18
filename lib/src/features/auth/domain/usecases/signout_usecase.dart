import 'dart:async';
import 'package:bloc_api_integration/src/core/use_cases/use_case.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:fpdart/fpdart.dart';
import '../repositories/auth_repository.dart';

class SignOutUsecase extends UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  SignOutUsecase(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await authRepository.signOut();
  }
}
