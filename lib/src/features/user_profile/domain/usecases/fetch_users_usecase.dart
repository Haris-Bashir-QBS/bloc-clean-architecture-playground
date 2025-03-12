import 'package:bloc_api_integration/src/core/use_cases/use_case.dart';
import 'package:bloc_api_integration/src/features/user_profile/data/repositories/users_repository_impl.dart';
import 'package:bloc_api_integration/src/features/user_profile/domain/entities/user.dart';
import 'package:bloc_api_integration/src/features/user_profile/domain/entities/user_listing.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../network/api_exceptions.dart';
import '../repositories/user_repository.dart';

class FetchUsersUseCase extends UseCase<UserListingEntity, int> {
  final UserRepository repository;

  FetchUsersUseCase(this.repository);

  @override
  Future<Either<Failure, UserListingEntity>> call(int page) {
    return repository.fetchUsers(page);
  }
}
