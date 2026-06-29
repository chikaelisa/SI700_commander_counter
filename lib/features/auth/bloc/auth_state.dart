import '../models/app_user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AppUser user;

  const AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}
