import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/data/datasources/remote/auth_service_remote_data_source.dart';
import 'package:tik_talk/data/repositories/auth_repository_IMPL.dart';
import 'package:tik_talk/data/services/auth_service.dart';
import 'package:tik_talk/domain/repositories/auth_repository.dart';

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
        baseUrl: "http://192.168.0.142:8080",
        localDataSource: container.get<AuthLocalDataSource>(),
      ),
    );

    container.registerLazySingleton<AuthService>(
      () => AuthService(container.get<ApiClient>()),
    );

    container.registerLazySingleton(
      () => AuthRemoteDataSource(service: container.get<AuthService>()),
    );
  }

  void _initRepositories() {
    container.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: container.get<AuthRemoteDataSource>(),
        local: container.get<AuthLocalDataSource>(),
      ),
    );
  }

}
