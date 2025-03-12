import 'package:bloc_api_integration/src/features/user_profile/data/models/user_model.dart';
import 'package:bloc_api_integration/src/features/user_profile/domain/entities/user.dart';

class UserListingEntity{
  final int?   page;
  final int? perPage;
  final int? total;
  final int? totalPages;
  final List<UserEntity>? users;

  UserListingEntity({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.users,
  });
  }