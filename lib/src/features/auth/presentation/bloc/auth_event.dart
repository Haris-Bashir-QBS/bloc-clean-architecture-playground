abstract class AuthEvent {}

class AuthSignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthSignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInEvent({required this.email, required this.password});
}

final class AuthIsUserLoggedInEvent extends AuthEvent {}

final class AuthSignOutEvent extends AuthEvent {}
