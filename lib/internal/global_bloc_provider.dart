import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/data/datasources/remote/auth_service_remote_data_source.dart';
import 'package:tik_talk/data/repositories/auth_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/home_repository_MOK.dart';
import 'package:tik_talk/data/services/auth_service.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/internal/app_router.dart';
import 'package:tik_talk/internal/application.dart';
import 'package:tik_talk/internal/di.dart';

class GlobalBlocProvider extends StatelessWidget {
  const GlobalBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AuthBloc(
        AuthRepositoryImpl(
          remote: AuthRemoteDataSource(
            service: DIContainer().container.get<AuthService>(),
          ),
          local: DIContainer().container.get<AuthLocalDataSource>(),
        ),
      )..add(AppStarted()),
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (prev, curr) => prev.status != curr.status,
        builder: (context, authState) {
          if (authState.status == AuthStatus.autheficated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<AuthBloc>()),
                BlocProvider(
                  create: (ctx) => HomeBloc(
                    MockHomeRepository(),
                    ctx.read<AuthBloc>(),
                  )..add(LoadEvent()),
                ),
              ],
              child: Application(router: AppRouter().router),
            );
          }

          // до авторизации (Splash, Auth)
          return Application(router: AppRouter().router);
        },
      ),
    );
  }
}
