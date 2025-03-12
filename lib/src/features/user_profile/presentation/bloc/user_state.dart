import 'package:bloc_api_integration/src/features/user_profile/domain/entities/user_listing.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

/// Initial state when nothing has happened yet
class UserInitial extends UserState {}

/// Loading state when fetching user profile
class UserLoading extends UserState {}

/// Success state when user profile is loaded
class UserLoaded extends UserState {
  final UserEntity user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];

  UserLoaded copyWith({UserEntity? user}) {
    return UserLoaded(user ?? this.user);
  }
}

class UserListingLoaded extends UserState {
  final UserListingEntity userListing;

  const UserListingLoaded({required this.userListing});

  @override
  List<Object> get props => [userListing];

  UserListingLoaded copyWith({
    List<UserEntity>? users,
    int? page,   int? perPage,   int? total,   int? totalPages,
  }) {
    return UserListingLoaded(
      userListing: UserListingEntity(
        users: users ?? userListing.users,
        page: page ?? userListing.page,
        perPage: perPage??userListing.perPage,
        total: total??userListing.total,
        totalPages: totalPages ?? userListing.totalPages,
      ),
    );
  }
}


/// Error state when fetching user profile fails
class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
