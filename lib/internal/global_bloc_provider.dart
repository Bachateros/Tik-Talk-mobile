import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/data/datasources/auth_local_data_source.dart';
import 'package:tik_talk/data/datasources/auth_service_remote_data_source.dart';
import 'package:tik_talk/data/repositories/auth_repository_IMPL.dart';
import 'package:tik_talk/data/services/auth_service.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/internal/app_router.dart';
import 'package:tik_talk/internal/application.dart';
import 'package:tik_talk/internal/di.dart';

class GlobalBlocProvider extends StatelessWidget {
  const GlobalBlocProvider({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => AuthBloc(
            AuthRepositoryImpl(
              remote: AuthRemoteDataSource(
                service: DIContainer().container.get<AuthService>(),
              ),
              local: DIContainer().container.get<AuthLocalDataSource>()
              
              ),
          ) ..add(AppStarted())
        ),
      ],
      child: Application(router:  AppRouter().router),
    );
  }
}
