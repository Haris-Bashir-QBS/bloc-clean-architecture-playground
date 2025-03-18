import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_api_integration/src/features/auth/domain/usecases/current_user_usecase.dart';
import 'package:bloc_api_integration/src/features/auth/domain/usecases/signin_usecase.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/common/cubits/app_user_cubit.dart';
import '../../../../core/use_cases/use_case.dart';
import '../../../../network/api_exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/signout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  final SignInUseCase _signInUseCase;
  final CurrentUserUsecase _currentUserUsecase;
  final AppUserCubit _authUserCubit;
  final SignOutUsecase _signOutUsecase;
  AuthBloc({
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
    required CurrentUserUsecase currentUserUsecase,
    required AppUserCubit authUserCubit,
    required SignOutUsecase signOutUsecase,
  }) : _signUpUseCase = signUpUseCase,
       _signInUseCase = signInUseCase,
       _currentUserUsecase = currentUserUsecase,
       _signOutUsecase = signOutUsecase,
       _authUserCubit = authUserCubit,
       super(AuthInitial()) {
    on<AuthSignUpEvent>(_onAuthSignup);
    on<AuthSignInEvent>(_onAuthSignIn);
    on<AuthSignOutEvent>(_onAuthSignOut);
    on<AuthIsUserLoggedInEvent>(_onAuthIsUserLoggedIn);
  }

  FutureOr<void> _onAuthIsUserLoggedIn(
    AuthIsUserLoggedInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final Either<Failure, UserEntity> result = await _currentUserUsecase(
      NoParams(),
    );
    result.fold(
      (Failure failure) {
        emit(AuthFailure(failure.message));
      },
      (UserEntity user) {
        print("Auth session success ${user.id}");
        _authUserCubit.updateUser(user);
        emit(AuthSuccess(user: user));
      },
    );
  }

  void _onAuthSignup(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, UserEntity> result = await _signUpUseCase(
      UserSignupParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (Failure failure) {
        emit(AuthFailure(failure.message));
      },
      (UserEntity user) {
        _authUserCubit.updateUser(user);
        emit(AuthSuccess(user: user));
      },
    );
  }

  void _onAuthSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, UserEntity> result = await _signInUseCase(
      UserSignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (Failure failure) {
        emit(AuthFailure(failure.message));
      },
      (UserEntity user) {
        _authUserCubit.updateUser(user);
        emit(AuthSuccess(user: user));
      },
    );
  }

  void _onAuthSignOut(AuthSignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, bool> result = await _signOutUsecase(NoParams());

    result.fold(
      (Failure failure) {
        emit(AuthFailure(failure.message));
      },
      (bool loggedOut) {
        _authUserCubit.updateUser(null);
        emit(AuthSignedOut());
      },
    );
  }
}
