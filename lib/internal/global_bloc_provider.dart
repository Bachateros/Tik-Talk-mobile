import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/data/datasources/remote/auth_service_remote_data_source.dart';
import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/message_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/participiant_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/user_service_remote_source.dart';
import 'package:tik_talk/data/repositories/auth_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/home_repository_IMPL.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/internal/app_router.dart';
import 'package:tik_talk/internal/application.dart';
import 'package:tik_talk/internal/di.dart';

class GlobalBlocProvider extends StatelessWidget {
  const GlobalBlocProvider({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
        create: (ctx) =>AuthBloc(
          repository: AuthRepositoryImpl(
            remote: DIContainer().container.get<AuthRemoteDataSource>(),
            local:  DIContainer().container.get<AuthLocalDataSource>(),
          )
        )..add(AppStarted()),
      ),
      BlocProvider<HomeBloc>(
        create: (ctx) => HomeBloc(
          repository: HomeRepositoryImpl(
            chatService: DIContainer().container.get<ChatsServiceRemoteSource>(), 
            userService: DIContainer().container.get<UserServiceRemoteSource>(), 
            participantService: DIContainer().container.get<ParticipiantServiceRemoteSource>(), 
            messageService: DIContainer().container.get<MessageServiceRemoteSource>()
            ), 
          authBloc: ctx.read<AuthBloc>()),          
      ), 
      ],
      child: Application(router: AppRouter().router),
    );
  }
}
