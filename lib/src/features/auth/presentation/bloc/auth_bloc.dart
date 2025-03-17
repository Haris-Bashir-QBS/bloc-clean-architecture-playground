import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../network/api_exceptions.dart';
import '../../../user_profile/domain/entities/user.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUpUseCase;
  AuthBloc({required SignUpUseCase signUpUseCase})
    : _signUpUseCase = signUpUseCase,
      super(AuthInitial()) {
    on<AuthSignUp>(_init);
  }

  void _init(AuthSignUp event, Emitter<AuthState> emit) async {
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
      (UserEntity response) {
        emit(AuthSuccess(userId: response.id.toString()));
      },
    );
  }
}
