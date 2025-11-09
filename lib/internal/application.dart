import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/presintation/theme/theme.dart';

class Application extends StatelessWidget {
 
  final GoRouter router;
  const Application({super.key,required this.router});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(

      listenWhen: (previous, current) => 
      previous.status != current.status && 
      (current.status == AuthStatus.autheficated || 
      current.status == AuthStatus.unautheficated),
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.autheficated:{
            context.read<HomeBloc>().add(LoadEvent());
            router.go('/home/');
            break;
          }          
          case AuthStatus.unautheficated:
            router.go('/auth');
            break;
          default:
            break;
        }
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: router,
      ),
    );
  }
}
