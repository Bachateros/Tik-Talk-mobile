import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/data/datasources/remote/auth_service_remote_data_source.dart';
import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/message_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/participiant_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/search_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/user_service_remote_source.dart';
import 'package:tik_talk/data/repositories/auth_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/chat_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/home_repository_IMPL.dart';
import 'package:tik_talk/data/repositories/home_repository_MOK.dart';
import 'package:tik_talk/domain/repositories/auth_repository.dart';
import 'package:tik_talk/domain/repositories/chat_repository.dart';
import 'package:tik_talk/domain/repositories/home_repository.dart';

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

  Future<void> _initLocalServices() async {
    final prefs = await SharedPreferences.getInstance();
    container.registerLazySingleton(
      () => AuthLocalDataSource(prefs)
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
      () => AuthRemoteDataSource(apiClient:  container.get<ApiClient>()),
    );

    container.registerLazySingleton(
      () => ChatsServiceRemoteSource(apiClient:  container.get<ApiClient>())
    );

    container.registerLazySingleton(
      () => MessageServiceRemoteSource(apiClient:  container.get<ApiClient>())
    );

    container.registerLazySingleton(
      () => ParticipiantServiceRemoteSource(apiClient:  container.get<ApiClient>())
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
        chatService: container.get<ChatsServiceRemoteSource>(),
        messageService: container.get<MessageServiceRemoteSource>(),
        participantService: container.get<ParticipiantServiceRemoteSource>(),
        userService: container.get<UserServiceRemoteSource>(),
      ),
    );

    container.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(
        chatsService: container.get<ChatsServiceRemoteSource>(),
        messageService: container.get<MessageServiceRemoteSource>(),
        participantService: container.get<ParticipiantServiceRemoteSource>()),
    );
  }

}
