import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/data/datasources/db/app_db.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/data/websocket/websocket.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/entities/home_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/home_repository.dart';
import 'package:tik_talk/domain/repositories/sync_repository.dart';
import 'package:tik_talk/internal/di.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;
  late final StreamSubscription _sub;
  final AuthBloc authBloc;

  HomeBloc({required this.repository, required this.authBloc}) : super(HomeState.initial()){
    _sub = authBloc.stream.listen((event) {
      if (event.status == AuthStatus.autheficated) {
        // load data
        Future.delayed(Duration(milliseconds: 100),
         () {
          add(LoadEvent());
        }
        );

      }
    });
    
    on<LoadEvent>(_onLoadDate);
    on<UpdateEvent>(_onUpdateDate);
  }

  @override
  Future<void> close() {
    _sub.cancel();  // отписываемся при закрытии
    return super.close();
  }

  Future<void> _onLoadDate(LoadEvent event, Emitter emit) async {
    try {
      final authLocal = DIContainer().container.get<AuthLocalDataSource>();
      //инициализация БД
          // final authLocal = DIContainer().container.get<AuthLocalDataSource>();
      final userId = await authLocal.getUserId();
      if (userId == null) throw Exception("User not logged in");

      // Инициализация базы под конкретного пользователя
      await DIContainer().initDbForUser(userId: userId);
      // await DIContainer().clearDbTables();
      // await DIContainer().deleteUserDb(userId);
      // await DIContainer().initDbForUser(userId: userId);
      // Получаем актуальные зависимости
      final db = DIContainer().container.get<AppDb>();
      final syncRepo = DIContainer().container.get<SyncRepository>();

      // Выполняем синхронизацию
      await syncRepo.printAllTables();
      await syncRepo.syncAll();
      await syncRepo.printAllTables();

      //Инициализация WebSocket
      await DIContainer().initSocket(appDB: db);
      final ws = DIContainer().container.get<WebSocketService>();
      await ws.connect();

      //

      emit(state.copyWith(status: HomeStatus.success));
      // final id = authBloc.state.userModel.userId;
      // final chats = await repository.getChats();
      // final contacts = await repository.getParticipant(chats);
      // final users = await repository.getUsers();
      // final lastMessages = await repository.getLastMessages(chats);
      // emit(state.copyWith(
      //   status: HomeStatus.success, 
      //   homeModel: state.homeModel.copyWith(chats: chats , lastMessages: lastMessages.whereType<ChatWithLastMessageEntitie>().toList()),
      //   listContacts: contacts,
      //   users: users,
      //   userId: id,
      //   ),);    
      } catch (e) {
      print('Ошибка загрузки данных: $e');
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onUpdateDate(UpdateEvent event, Emitter emit) async {
    try {
      // final chats = await repository.getChats();
      // final contacts = await repository.getParticipant(chats);
      // final users = await repository.getUsers();
      // final lastMessages = await repository.getLastMessages(chats);
      emit(state.copyWith(
        status: HomeStatus.success, 
        /* homeModel: state.homeModel.copyWith(chats: chats , lastMessages: lastMessages.whereType<ChatWithLastMessageEntitie>().toList() */),
        /* listContacts: contacts,
        users: users), */);
    } catch (e) {
      print('Ошибка обновления данных: $e');
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}

