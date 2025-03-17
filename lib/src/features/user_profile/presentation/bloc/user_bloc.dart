import 'dart:async';
import 'dart:developer';
import 'package:bloc_api_integration/src/features/user_profile/domain/usecases/fetch_users_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../network/api_exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_listing.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FetchUserProfileUseCase getUserProfileUseCase;
  final FetchUsersUseCase fetchUsersUseCase;
  int currentPage = 1;
  bool isFetching = false;
  int totalPages = 1;
  UserBloc(this.getUserProfileUseCase, this.fetchUsersUseCase)
    : super(UserInitial()) {
    on<FetchUserProfileEvent>(_fetchUserProfile);
    on<FetchUsersEvent>(_fetchUserListing);
  }

  FutureOr<void> _fetchUserListing(
    FetchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;
    if (isFetching) return;
    isFetching = true;
    if (event.page == 1) {
      currentPage = 1;
      totalPages = 1;
      emit(UserLoading());
    }
    await Future.delayed(Duration(microseconds: 800));
    final Either<Failure, UserListingEntity> result = await fetchUsersUseCase(
      event.page,
    );

    result.fold(
      (Failure failure) {
        emit(UserError(failure.message));
      },
      (UserListingEntity paginatedData) {
        final newUsers = paginatedData.users;
        if (currentState is UserListingLoaded) {
          if (event.page == 1) {
            emit(UserListingLoaded(userListing: paginatedData));
          } else {
            emit(
              currentState.copyWith(
                users: [...?currentState.userListing.users, ...?newUsers],
                page: paginatedData.page,
                totalPages: paginatedData.totalPages,
              ),
            );
          }
          ;
        } else {
          emit(UserListingLoaded(userListing: paginatedData));
        }

        currentPage = paginatedData.page! + 1;
        log("Current page is $currentPage");
        totalPages = paginatedData.totalPages!;
      },
    );

    isFetching = false;
  }

  FutureOr<void> _fetchUserProfile(
    FetchUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await getUserProfileUseCase(event.userId);
    result.fold(
      (Failure failure) => emit(UserError(failure.message)),
      (UserProfileEntity user) => emit(UserLoaded(user)),
    );
  }
}
