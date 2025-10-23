import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tik_talk/bloc/AuthProvider.dart';

class HomeScene extends StatelessWidget {
  const HomeScene({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context); 
    final username = auth.user?.name ?? 'Пользователь';

    return Scaffold(
      appBar: AppBar(
        title: Text('Home — привет, $username'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
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