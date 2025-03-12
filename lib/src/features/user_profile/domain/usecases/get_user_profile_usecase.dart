import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/use_cases/use_case.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';


/// Interacts with the repository to get user data

class FetchUserProfileUseCase implements UseCase<UserEntity, String> {
  final UserRepository repository;

  FetchUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(String id) {
    return repository.fetchUser(id);
  }
}
