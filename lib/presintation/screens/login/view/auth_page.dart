import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/presintation/screens/login/view/auth_view.dart';
import 'package:tik_talk/presintation/widgets/background_picture_auth.dart';


class AuthPage extends StatelessWidget {
  final Widget child;
  const AuthPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $errorMessage')),
          );
        }
      },
      child: BackgroundPicture(
        topPadding: 180,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child:/* SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child:  */AuthView(),
            // ),
          ),
        ),
      ),
    );
  }
}