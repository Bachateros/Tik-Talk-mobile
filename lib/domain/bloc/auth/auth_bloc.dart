import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/data/DTO/user_DTO.dart';
import 'package:tik_talk/data/datasources/db/app_db.dart';
import 'package:tik_talk/data/repositories/sync_repository_IMPL.dart';
import 'package:tik_talk/data/websocket/websocket.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/auth_repository.dart';
import 'package:tik_talk/domain/repositories/sync_repository.dart';
import 'package:tik_talk/internal/di.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<VerifyEvent>(_onVerify);
    on<LogoutEvent>(_onLogout);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<CheckAuthEvent>(_onCheckAuth);
    on<RegisterPressedEvent>(_onRegisterPressed);
    on<LoginPressedEvent>(_onLoginPressed);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      // final user = await repository.logout();
      await repository.refreshToken();
      final id = await repository.hasValidTokens();
      if (id!=null) {
        try{
          // Инициализация базы под конкретного пользователя
          await DIContainer().initDbForUser(userId: id);
          // await DIContainer().clearDbTables();
          // await DIContainer().deleteUserDb(userId);
          // await DIContainer().initDbForUser(userId: userId);
          // Получаем актуальные зависимости
          final db = DIContainer().container.get<AppDb>();
          final syncRepo = DIContainer().container.get<SyncRepository>();
          // await syncRepo.printAllTables();
          await syncRepo.syncAll();
          // await syncRepo.printAllTables();

          //Инициализация WebSocket
          await DIContainer().initSocket(appDB: db);
          final ws = DIContainer().container.get<WebSocketService>();
          await ws.connect();
        }catch(e){
          throw ('Bad BD init and ws connect try destroy');
        }
        emit(state.copyWith(status: AuthStatus.autheficated));
      } else {
        emit(state.copyWith(status: AuthStatus.unautheficated));
      }
    } catch (e) {
      print('Ошибка проверки токена: $e');
      await repository.logout();
      emit(state.copyWith(
        status: AuthStatus.unautheficated,
        errorMessage: 'Ошибка проверки токена: $e',
      ));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await repository.login(event.tgUsername, event.password);
      if (user.userId != '') {
        emit(
          state.copyWith(
            status: AuthStatus.verify, 
            userModel: state.userModel.copyWith(
                                        userId: user.userId, 
                                        tgUsername: user.tgUsername),
                errorMessage: null
              )
            );
      }
    } catch (e) {
      print('Ошибка входа: $e');
      emit(state.copyWith(status: AuthStatus.unautheficated, userModel: UserEntity(), errorMessage:  'Ошибка входа: $e'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await repository.register(
        event.name,
        event.surname,
        event.tgUsername,
        event.password,
      );
      if (user.accesBotLink != null) {
        emit(state.copyWith(
          status: AuthStatus.registerBotLink,
          userModel: user,
          errorMessage: null
          )
        );
      } else {
        emit(state.copyWith(status: AuthStatus.register));
      }
    } catch (e) {
      print('Ошибка регистрации: $e');
      emit(state.copyWith(status: AuthStatus.register, errorMessage: 'Ошибка регистрации: $e'));
   
    }
  }

Future<void> _onVerify(VerifyEvent event, Emitter<AuthState> emit) async {
  final userId = state.userModel.userId;
  
  if (userId == '') {
    emit(state.copyWith(
      status: AuthStatus.unautheficated,
      errorMessage: 'Ошибка: отсутствует идентификатор пользователя',
    ));
    return;
  }

  try {
    final user = await repository.verify(userId, event.code);
    if (user.accessToken!=null && user.refreshToken!=null){
       try{
        // Инициализация базы под конкретного пользователя
        await DIContainer().initDbForUser(userId: userId);
        // await DIContainer().clearDbTables();
        // await DIContainer().deleteUserDb(userId);
        // await DIContainer().initDbForUser(userId: userId);
        // Получаем актуальные зависимости
        final db = DIContainer().container.get<AppDb>();
        final syncRepo = DIContainer().container.get<SyncRepository>();
        // await syncRepo.printAllTables();
        await syncRepo.syncAll();
        // await syncRepo.printAllTables();

        //Инициализация WebSocket
        await DIContainer().initSocket(appDB: db);
        final ws = DIContainer().container.get<WebSocketService>();
        await ws.connect();
      }catch(e){
        throw ('Bad BD init and ws connect try destroy');
      }
      emit(state.copyWith(status: AuthStatus.autheficated,errorMessage: null,));
    }
  } catch (e) {
    print('Ошибка верификации: $e');
    emit(state.copyWith(
      status: AuthStatus.unautheficated,
      errorMessage: 'Ошибка верификации: $e',
    ));
  }
}

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await repository.logout();
    emit(state.copyWith(status: AuthStatus.unautheficated));
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.refreshToken();
    } catch (e) {
      print('Ошибка logout: $e');
      await repository.logout();
      emit(state.copyWith(status: AuthStatus.unautheficated, errorMessage: 'Ошибка logout: $e'));
    }
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    final id = await repository.hasValidTokens();
    if (id!=null) {
      emit(state.copyWith(status: AuthStatus.autheficated));
    } else {
      await repository.logout();
      emit(state.copyWith(status: AuthStatus.unautheficated,errorMessage: null),);
    }
  }

  Future<void> _onRegisterPressed(RegisterPressedEvent event,Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.register));
    } catch (e) {
      print('Ошибка перехода на страницу регистрации: $e');
      emit(state.copyWith(status: AuthStatus.unautheficated));
    }
  }


  Future<void> _onLoginPressed(LoginPressedEvent event,Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.unautheficated));
    } catch (e) {
      print('Ошибка перехода на страницу авторизации: $e');
      emit(state.copyWith(status: AuthStatus.unautheficated));
    }
  }

}

