import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch user profile
class FetchUserProfileEvent extends UserEvent {
  final String userId;

  const FetchUserProfileEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class FetchUsersEvent extends UserEvent {
  final int page;

  const FetchUsersEvent(this.page);

  @override
  List<Object> get props => [page];

}