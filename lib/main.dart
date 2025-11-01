import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tik_talk/data/services/auth_service.dart';
import 'package:tik_talk/domain/repositories/auth_repository.dart';


import 'presintation/theme/theme.dart';
import 'presintation/router/auth_router.dart';

import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_service_remote_data_source.dart';
import 'data/repositories/auth_repository_IMPL.dart';

import 'presintation/bloc/auth/auth_bloc.dart';
import 'presintation/bloc/auth/auth_event.dart';
import 'presintation/bloc/auth/auth_state.dart';

import 'data/api_remote/ApiClient.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<AuthRepository> init() async {
    final prefs = await SharedPreferences.getInstance();
    final local = AuthLocalDataSource(prefs);
    final api = ApiClient(baseUrl: 'http://192.168.0.142:8080', localDataSource: local);
    final service = AuthService(api);
    final remote = AuthRemoteDataSource(service);
    return AuthRepositoryImpl(remote: remote, local: local);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthRepository>(
      future: init(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }

        final authRepo = snapshot.data!;
        return BlocProvider(
          create: (_) => AuthBloc(authRepo)..add(AppStarted()),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const AuthRouter(),
          ),
        );
      },
    );
  }
}