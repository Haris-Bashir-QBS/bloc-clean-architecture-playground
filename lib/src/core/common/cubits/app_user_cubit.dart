import 'dart:developer';

import 'package:bloc_api_integration/src/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(UserEntity? user) {
    if (user == null) {
      log("User null");

      /// initial shows logged out state
      emit(AppUserInitial());
    } else {
      log("User Not null");
      emit(AppUserLoggedIn(user: user));
    }
  }
}
