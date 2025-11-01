import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/presintation/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/presintation/bloc/auth/auth_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главная')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read<AuthBloc>().add(LogoutEvent()),
          child: const Text('Выйти'),
        ),
      ),
    );
  }
}
