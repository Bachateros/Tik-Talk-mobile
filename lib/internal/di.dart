import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/data/datasources/db/app_db.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/data/datasources/local/chats_dao.dart';
import 'package:tik_talk/data/datasources/local/messages_dao.dart';
import 'package:tik_talk/data/datasources/local/participants_dao.dart';
import 'package:tik_talk/data/datasources/local/users_dao.dart';
import 'package:tik_talk/data/datasources/remote/auth_service_remote_data_source.dart';
import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/message_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/participiant_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/search_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/sync_service_remote_data_service.dart';
import 'package:tik_talk/data/datasources/remote/user_service_remote_source.dart';
import 'package:tik_talk/data/mapers/chat_mapper.dart';
import 'package:tik_talk/data/mapers/message_mapper.dart';
import 'package:tik_talk/data/mapers/participant_mapper.dart';
import 'package:tik_talk/data/mapers/user_mapper.dart';
import 'package:tik_talk/data/repositories/auth_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/chat_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/create_chat_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/home_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/profile_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/settings_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/sync_repository_IMPL.dart';
import 'package:tik_talk/data/websocket/websocket.dart';
import 'package:tik_talk/domain/repositories/auth_repository.dart';
import 'package:tik_talk/domain/repositories/chat_repository.dart';
import 'package:tik_talk/domain/repositories/create_chat_repository.dart';
import 'package:tik_talk/domain/repositories/home_repository.dart';
import 'package:tik_talk/domain/repositories/profile_repository.dart';
import 'package:tik_talk/domain/repositories/settings_repository.dart';
import 'package:tik_talk/domain/repositories/sync_repository.dart';
import 'package:path/path.dart' as p;


class DIContainer {
  // creating singleton
  static final DIContainer _instance = DIContainer._();

  DIContainer._();

  factory DIContainer() {
    return _instance;
  }

  // variables
  final GetIt _container = GetIt.instance;

  // getter
  GetIt get container => _container;

  static Future<void> init() async {
    await _instance._initLocalServices();
    _instance._initRemoteServices();
    _instance._initRepositories();
    // await _instance._initDatabase();
    // _instance._initServices();
    // await _instance._initRepositories(info);
    // await _instance._initPushNotification();
    // _instance._initBloc();
  }

  Future<void> initSocket({required AppDb appDB}) async {
    final authLocal = container.get<AuthLocalDataSource>();
    final token = await authLocal.getAccessToken();

    container.registerSingleton(WebSocketService(
      baseUrl: 'ws://192.168.0.142:8080/connect',
      token: token!,
      db: appDB,
    ));
  }

  Future<void> initDbForUser({required String userId}) async {
    final dbName = 'app_$userId.db';

    // Если уже есть база
    if (_container.isRegistered<AppDb>()) {
      final old = _container.get<AppDb>();

      // Если текущий пользователь совпадает — ничего не делаем
      if (old.currentUserId == userId) {
        return;
      }

      // Иначе закрываем старую базу, но не удаляем файлы
      final userIdDb = await old.userId;
      await deleteUserDb(userIdDb);
      _container.unregister<AppDb>();
    }

    // Создаём новую базу с уникальным именем для пользователя
    final newDb = AppDb(dname: dbName, userId: userId);
    _container.registerSingleton<AppDb>(newDb);

    container.registerLazySingleton<SyncRepository>(
      () => SyncRepositoryIMPL (db: newDb,syncService: container.get<SyncServiceRemoteDataService>())
      );  

    container.registerLazySingleton(
      () => ChatsDao(container.get<AppDb>()),
    );
    
    container.registerLazySingleton(
      () => MessagesDao(container.get<AppDb>()),
    );

    container.registerLazySingleton(
      () => UsersDao(container.get<AppDb>()),
    );

    container.registerLazySingleton(
      () => ParticipantsDao(container.get<AppDb>()),
    );
  }


  /// Полное удаление базы данных пользователя
  Future<void> deleteUserDb(String userId) async {
    if (_container.isRegistered<AppDb>()) {
      final db = _container.get<AppDb>();
      await db.close();
      await db.deleteFile(); // удаляет физически
      // _container.unregister<AppDb>();
    } else {
      // даже если база не зарегистрирована — подстрахуемся
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'app_$userId.db'));
      if (await file.exists()) await file.delete();
    }
  }

  /// Очистка таблиц без удаления базы
  Future<void> clearDbTables() async {
    if (!_container.isRegistered<AppDb>()) return;

    final db = _container.get<AppDb>();

    if (!db.dbIsOpen) {
      print('⚠️ Database closed! Cannot clear tables.');
      return;
    }

    await db.transaction(() async {
      await db.delete(db.users).go();
      await db.delete(db.messages).go();
      await db.delete(db.chats).go();
      await db.delete(db.participants).go();
      await db.delete(db.syncMeta).go();
    });
  }

  Future<void> _initLocalServices() async {
    final prefs = await SharedPreferences.getInstance();
    container.registerLazySingleton(
      () => AuthLocalDataSource(prefs)
    );

    container.registerLazySingleton(
      ()=> ChatMapper(),
    );

    container.registerLazySingleton(
      ()=> MessageMapper(),
    );
    
    container.registerLazySingleton(
      ()=> UserMapper(),
    );

    container.registerLazySingleton(
      ()=> ParticipantMapper(),
    );
  }

  void _initRemoteServices() {
    container.registerLazySingleton(
      () => ApiClient(
        // baseUrl: "http://10.80.69.137:8080",//mobile Wifi ip
        baseUrl: "http://192.168.0.142:8080",
        localDataSource: container.get<AuthLocalDataSource>(),
      ),
    );

    container.registerLazySingleton(
      () => SyncServiceRemoteDataService(
        apiClient:  container.get<ApiClient>()
        ),
    );

    container.registerLazySingleton(
      () => AuthRemoteDataSource(
        apiClient:  container.get<ApiClient>()
        ),
    );

    container.registerLazySingleton(
      () => ChatsServiceRemoteSource(
        chatMapper: container.get<ChatMapper>(),
        participantMapper: container.get<ParticipantMapper>(),
        apiClient:  container.get<ApiClient>()
        ),
    );

    container.registerLazySingleton(
      () => MessageServiceRemoteSource(
        messageMapper: container.get<MessageMapper>(),
        apiClient:  container.get<ApiClient>()
        )
    );

    container.registerLazySingleton(
      () => ParticipiantServiceRemoteSource(
        apiClient:  container.get<ApiClient>(),
        mapper: container.get<ParticipantMapper>()
        ),
    );

    container.registerLazySingleton(
      () => SearchServiceRemoteSource(apiClient:  container.get<ApiClient>())
    );

    container.registerLazySingleton(
      () => UserServiceRemoteSource(apiClient:  container.get<ApiClient>())
    );
  }

  void _initRepositories() {
    container.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: container.get<AuthRemoteDataSource>(),
        local: container.get<AuthLocalDataSource>(),
      ),
    );

    container.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        chatsDao: container.get<ChatsDao>(),
        messagesDao: container.get<MessagesDao>(),
        participantsDao: container.get<ParticipantsDao>(),
        usersDao: container.get<UsersDao>(),
      ),
    );

    container.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
        chatMapper: container.get<ChatMapper>(),
        participantMapper: container.get<ParticipantMapper>(),
        messageMapper: container.get<MessageMapper>(),
        chatsDao: container.get<ChatsDao>(),
        messagesDao: container.get<MessagesDao>(),
        participantsDao: container.get<ParticipantsDao>(),
        chatsService: container.get<ChatsServiceRemoteSource>(),
        messageService: container.get<MessageServiceRemoteSource>(),
        participantService: container.get<ParticipiantServiceRemoteSource>(), 
        syncService: container.get<SyncServiceRemoteDataService>()
        ),
        
    );

    container.registerLazySingleton<ProfileRepository>(
      ()=> ProfileRepositoryImpl(
        userMapper: container.get<UserMapper>(),
        userRepo: container.get<UserServiceRemoteSource>(),
        usersDao: container.get<UsersDao>(),
        )
    );

    container.registerLazySingleton<CreateChatRepository>(
      ()=>CreateChatRepositoryImpl(
        participantMapper: container.get<ParticipantMapper>(), 
        chatsDao: container.get<ChatsDao>(), 
        participantsDao: container.get<ParticipantsDao>(), 
        chatsService: container.get<ChatsServiceRemoteSource>(), 
        chatMapper: container.get<ChatMapper>())
    );

    container.registerLazySingleton<SettingsRepository>(
      ()=>SettingsRepositoryImpl(),
    );
  }

}
