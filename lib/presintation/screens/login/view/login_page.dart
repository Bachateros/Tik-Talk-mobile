import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/presintation/screens/login/view/login_view.dart';
import 'package:tik_talk/presintation/screens/login/view/register_view.dart';
import 'package:tik_talk/presintation/screens/login/view/verify_view.dart';
import 'package:tik_talk/presintation/screens/splash/splash_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder в качестве примера, где стоит его создавать
    // Вместо BlocBuilder по хорошему здесь BlocProvider для всех блоков, которые нужны на странице
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {        
        if (state.status == AuthStatus.unknown) {
          return CircularProgressIndicator();
        } else if (state.status == AuthStatus.unautheficated){
          return Scaffold(body: LoginView());
        } else if (state.status == AuthStatus.register){
          return Scaffold(body: RegisterView());
        } else if (state.status == AuthStatus.registerBotLink){
          return Scaffold(body: RegisterView(user: state.userModel));
        } else if (state.status == AuthStatus.verify){
          return Scaffold(body: VerifyView());
        } return SplashScreen();
      },
    );
  }
}
