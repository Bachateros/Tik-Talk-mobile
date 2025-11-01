import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tik_talk/presintation/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/presintation/bloc/auth/auth_state.dart';

import 'package:tik_talk/presintation/screens/login_page.dart';
import 'package:tik_talk/presintation/screens/registration_page.dart';
import 'package:tik_talk/presintation/screens/verify_page.dart';
import 'package:tik_talk/presintation/screens/home_page.dart';




class AuthRouter extends StatelessWidget {
  const AuthRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoginState) return const LoginPage();
        if (state is RegisterState) return const RegisterPage();
        if (state is VerifyState) return VerifyPage(userId: state.userId);
        if (state is AuthenticatedState) return const HomePage();
        if (state is LogoutState) return const LoginPage();
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
