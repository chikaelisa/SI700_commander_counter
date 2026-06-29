import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_data_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthDataProvider dataProvider;

  AuthBloc({required this.dataProvider}) : super(const AuthUnauthenticated()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await dataProvider.signIn(
        email: event.email,
        password: event.password,
      );

      emit(AuthAuthenticated(user));
    } catch (_) {
      emit(
        const AuthError(
          'Não foi possível entrar. Verifique seus dados e tente novamente.',
        ),
      );
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await dataProvider.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      emit(AuthAuthenticated(user));
    } catch (_) {
      emit(
        const AuthError('Não foi possível criar sua conta. Tente novamente.'),
      );
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await dataProvider.signOut();

      emit(const AuthUnauthenticated());
    } catch (_) {
      emit(const AuthError('Não foi possível sair da conta.'));
    }
  }
}
