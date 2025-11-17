import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/presintation/screens/login/widgets/login_form.dart';
import 'package:tik_talk/presintation/screens/login/widgets/register_complete_url_aligin.dart';
import 'package:tik_talk/presintation/screens/login/widgets/register_form.dart';
import 'package:tik_talk/presintation/screens/login/widgets/verify_form.dart';
import 'package:tik_talk/presintation/screens/splash/splash_screen.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case AuthStatus.unknown:
              return SplashScreen();
            case AuthStatus.unautheficated:
              return LoginForm();
            case AuthStatus.register:
              return RegisterForm();
            case AuthStatus.registerBotLink:{
              final botLink = context.read<AuthBloc>().state.accesBotLink;
              return RegisterCompleteForm(botLink: botLink!);
            }
            case AuthStatus.verify:
              return VerifyForm();
          default:
            return  Padding(
              padding: EdgeInsetsGeometry.only(top: 230),
              child: Center(
                child: CircularProgressIndicator()
              ),
            );   
          }
        }
      );
  }
}