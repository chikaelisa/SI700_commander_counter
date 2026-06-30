import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import 'widgets/profile_logged_in_view.dart';
import 'widgets/sign_in_view.dart';
import 'widgets/sign_up_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isSignUpMode = false;

  void toggleMode() {
    setState(() {
      isSignUpMode = !isSignUpMode;
    });
  }

  void signIn() {
    context.read<AuthBloc>().add(
      const AuthSignInRequested(
        email: 'user@commander-counter.local',
        password: 'password',
      ),
    );
  }

  void signUp() {
    context.read<AuthBloc>().add(
      const AuthSignUpRequested(
        name: 'Usuário Commander',
        email: 'user@commander-counter.local',
        password: 'password',
      ),
    );
  }

  void signOut() {
    context.read<AuthBloc>().add(const AuthSignOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AuthAuthenticated) {
          return ProfileLoggedInView(onLogout: signOut);
        }

        if (isSignUpMode) {
          return SignUpView(onSignUp: signUp, onGoToSignIn: toggleMode);
        }

        return SignInView(onSignIn: signIn, onGoToSignUp: toggleMode);
      },
    );
  }
}
