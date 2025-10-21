import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tik_talk/bloc/AuthProvider.dart';

class HomeScene extends StatelessWidget {
  const HomeScene({super.key});

  @override
  Widget build(BuildContext context) {
    // Здесь используем context.watch чтобы UI обновлялся при изменениях в AuthProvider.
    final auth = Provider.of<AuthProvider>(context); // можно .watch(context) в новом API

    final username = auth.user?.name ?? 'Пользователь';

    return Scaffold(
      appBar: AppBar(
        title: Text('Home — привет, $username'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              // После logout возвращаемся на страницу логина
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Основной экран мессенджера — тут будет список чатов'),
      ),
    );
  }
}