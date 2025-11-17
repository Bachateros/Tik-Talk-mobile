import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/data/websocket/websocket.dart';
import 'package:tik_talk/data/websocket/ws_event_bus.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/entities/last_message_chat_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/home_repository.dart';
import 'package:tik_talk/domain/repositories/sync_repository.dart';
import 'package:tik_talk/internal/di.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;
  final WebSocketService ws;
  final AuthBloc authBloc;
  final SyncRepository syncRepo;


  late final StreamSubscription _authSub;
  late final StreamSubscription _wsSub;

  HomeBloc({
    required this.repository,
    required this.authBloc,
    required this.ws,
    required this.syncRepo
  }) : super(HomeState.initial()) {

    // слушаем авторизацию
    _authSub = authBloc.stream.listen((event) {
      if (event.status == AuthStatus.autheficated) {
        add(LoadEvent());
      }
    });

    // слушаем события из WebSocket
    _wsSub = WsEventBus().stream.listen((event) async {
      final type = event['type'];
      final action = event['action'];
      switch (type) {
        case 'connection_established':
          add(UpdateClientIdWS(event['client_id'].toString()));
          break;
        case 'participant':{
          switch(action){
            case 'deleted':{
              await syncRepo.markChatDeleted(event['chat_id'].toString());
              }
              break;
            case 'removed':{
              await syncRepo.markParticipantDeleted(
                  event['chat_id'].toString(),
                  event['user_id'].toString());
                  }break;
            case 'added':{
              await syncRepo.syncChat(event['chat_id'].toString());
            }
          }       
          add(UpdateEvent());
        }
        case 'new_message':{
          syncRepo.syncMessages(event['chat_id'].toString());
          add(UpdateEvent());
        }
        
      }
    });

    on<LoadEvent>(_onLoadDate);
    on<UpdateEvent>(_onUpdateDate);
    on<UpdateClientIdWS>(_onUpdateClientIdWS);
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    _wsSub.cancel();
    return super.close();
  }

  Future<void> _onLoadDate(LoadEvent event, Emitter emit) async {
    try {   
      
      final authLocal = DIContainer().container.get<AuthLocalDataSource>();
      final userId = await authLocal.getUserId();

      if (userId == null) throw Exception("User not logged in");


      final user = await repository.getMy(userId);
      final users = await repository.getAllUsers();
      final contacts = await repository.getContacts(userId);
      final listLastMesseges= await repository.getLastMessages(userId);
      print(state.user!.clientId);
      emit(state.copyWith(status: HomeStatus.success,userId: userId,user: user, listLastMesseges : listLastMesseges,listContacts: contacts, users: users ), );
      } catch (e) {
      print('Ошибка загрузки данных: $e');
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onUpdateDate(UpdateEvent event, Emitter emit) async {
    try {      
      final listLastMesseges= await repository.getLastMessages(state.user!.userId);
      emit(state.copyWith(status: HomeStatus.success, listLastMesseges : listLastMesseges), );
    } catch (e) {
      print('Ошибка обновления данных: $e');
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> _onUpdateClientIdWS(UpdateClientIdWS event, Emitter emit)async{
    emit(state.copyWith(user: state.user!.copyWith(clientId: event.clientId)));
    print ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"*2);
    print(event.clientId);
    print(state.user?.clientId);
    print ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"*2);
  }
}

        ///здесь мне нужно сравнивать текущие чаты с изменениями в участниках
        ///(если практикант я и в сообщении указан чат которого у меня нет 
        ///нужно подтянуть обновленные данные с БД не забыть вызвать синхронизацию
        ///исключительно для этого чата подтянуть его данные но я пока просто думаю обновлять
        ///всю таблицу после каждого запроса, на нескольких пользователях не сломается ... надеюсь)
        
        ///{"chat_id":4,"user_id":1,"type":"participant","action":"entered"} – при входе пользователя в чат
        /// {"chat_id":1,"user_id":2,"type":"participant","action":"added"} – при добавлении пользователя в чат
        /// {"chat_id":2,"type":"participant","action":"deleted"}
        /// - при удалении чата
        /// {"chat_id":1,"user_id":1,"type":"participant","action":"removed"} – при удалении участника из чата
        /// {"chat_id":4,"user_id":1,"type":"participant","action":"leaved"} – при выходе участника из чата
        
        /// {"chat_id":1,"client_id":"1","content":"Просто сообщение 5","message_id":11,"message_type":"text","status":"delivered","timestamp":"2025-11-14T00:04:25.620045545Z","type":"new_message","user_id":1} – Пример сообщений

        /// По сообщениям, сервер корректно должен обработать 
        /// {
        ///   "chatId": "1",
        ///   "content": "123",
        ///   "type": "text",
        ///   "clientId": "1"
        /// }
      
        /// сообщения пока только текстовые clientId он возвращается с подключения в сообшение websocket
        /// type сообщений пока только текстовый, надеюсь более мы не будем реализовывать и нам этого хватит
        /// 
        /// Струкура запроса отправки сообщения - 
        /// {
        ///  /// "chatId" binding:"required"
        ///  /// "content" binding:"required"
        ///  /// "type" binding:"required,oneof=text image file system"
        ///  /// "replyToId,omitempty"
        ///  /// "fileUrl,omitempty"
        ///  /// "fileName,omitempty"
        ///  /// "fileSize,omitempty"
        ///  /// "mimeType,omitempty"
        ///  /// "clientId" binding:"required"
        /// }
        /// Такую структуру готов принимать серврер, но с файлами я не пробовал, и не особо хочется (postman вроде такое не позволяет)
        