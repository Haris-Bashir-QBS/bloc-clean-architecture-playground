import 'package:bloc_api_integration/src/features/auth/domain/entities/user_entity.dart';

class AppUserState {}

class AppUserInitial extends AppUserState {}

class AppUserLoggedIn extends AppUserState {
  final UserEntity user;

  AppUserLoggedIn({required this.user});
}

/// Core can't depend on other features ,features used in core can use core
