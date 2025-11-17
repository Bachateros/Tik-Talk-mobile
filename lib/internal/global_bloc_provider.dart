import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/data/datasources/local/chats_dao.dart';
import 'package:tik_talk/data/datasources/local/messages_dao.dart';
import 'package:tik_talk/data/datasources/local/participants_dao.dart';
import 'package:tik_talk/data/datasources/local/users_dao.dart';
import 'package:tik_talk/data/datasources/remote/auth_service_remote_data_source.dart';
import 'package:tik_talk/data/repositories/auth_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/home_repository_IMPL.dart';
import 'package:tik_talk/data/websocket/websocket.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/repositories/sync_repository.dart';
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
            chatsDao: DIContainer().container.get<ChatsDao>(),
            messagesDao: DIContainer().container.get<MessagesDao>(),
            participantsDao: DIContainer().container.get<ParticipantsDao>(),
            usersDao:DIContainer().container.get<UsersDao>(),
            ),
          syncRepo: DIContainer().container.get<SyncRepository>(),
          ws: DIContainer().container.get<WebSocketService>(), 
          authBloc: ctx.read<AuthBloc>()),          
      ), 
      ],
      child: Application(router: AppRouter().router),
    );
  }
}
