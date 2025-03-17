import 'package:bloc_api_integration/src/features/user_profile/domain/entities/user.dart';
import 'package:bloc_api_integration/src/network/api_exceptions.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user_listing.dart';

/// Abstract class defining methods that the repository must implement

abstract class UserRepository {
  Future<Either<Failure, UserProfileEntity>> fetchUser(String id);
  Future<Either<Failure, UserListingEntity>> fetchUsers(int page);
}
