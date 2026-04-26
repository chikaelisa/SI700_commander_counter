import 'package:flutter/material.dart';

import 'widgets/profile_logged_in_view.dart';
import 'widgets/sign_in_view.dart';
import 'widgets/sign_up_view.dart';

class ProfilePage extends StatefulWidget {
  final bool isLoggedIn;
  final VoidCallback onLogin;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.isLoggedIn,
    required this.onLogin,
    required this.onLogout,
  });

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

  @override
  Widget build(BuildContext context) {
    if (widget.isLoggedIn) {
      return ProfileLoggedInView(onLogout: widget.onLogout);
    }

    if (isSignUpMode) {
      return SignUpView(onSignUp: widget.onLogin, onGoToSignIn: toggleMode);
    }

    return SignInView(onSignIn: widget.onLogin, onGoToSignUp: toggleMode);
  }
}
