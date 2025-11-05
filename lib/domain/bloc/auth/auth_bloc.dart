import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/data/models/user_model.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<VerifyEvent>(_onVerify);
    on<LogoutEvent>(_onLogout);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<CheckAuthEvent>(_onCheckAuth);
    on<RegisterPressedEvent>(_onRegisterPressed);
  }

Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
  try {
    final id = await repository.hasValidTokens();
    if (id!=null) {
      final userFull = await repository.getMe(id);
      await repository.refreshToken();
      emit(state.copyWith(status: AuthStatus.autheficated,userModel: userFull));
    } else {
      emit(state.copyWith(status: AuthStatus.unautheficated));
    }
  } catch (e) {
    print('Ошибка проверки токена: $e');
    emit(state.copyWith(
      status: AuthStatus.unautheficated,
      errorMessage: 'Ошибка проверки токена: $e',
    ));
  }
}

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await repository.login(event.tgUsername, event.password);
      if (user.userId != null) {
        emit(state.copyWith(status: AuthStatus.verify, userModel: state.userModel.copyWith(userId: user.userId, tgUsername: user.tgUsername)));
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
        emit(state.copyWith(status: AuthStatus.registerBotLink,userModel: state.userModel.copyWith(name: event.name,surname: event.surname,tgUsername: event.tgUsername,accesBotLink: user.accesBotLink)));
      } else {
        emit(state.copyWith(status: AuthStatus.unautheficated));
      }
    } catch (e) {
      print('Ошибка регистрации: $e');
      emit(state.copyWith(status: AuthStatus.register,errorMessage: 'Ошибка регистрации: $e'));
   
    }
  }

Future<void> _onVerify(VerifyEvent event, Emitter<AuthState> emit) async {
  final userId = state.userModel.userId;

  if (userId == null) {
    emit(state.copyWith(
      status: AuthStatus.unautheficated,
      errorMessage: 'Ошибка: отсутствует идентификатор пользователя',
    ));
    return;
  }

  try {
    final user = await repository.verify(userId, event.code);
    if (user.accessToken!=null && user.refreshToken!=null){
      emit(state.copyWith(
            status: AuthStatus.autheficated,
            userModel: state.userModel.copyWith(
              accessToken: user.accessToken,
              refreshToken: user.refreshToken,
              name: user.name,
      ),
    ));
    }
    final userFull = await repository.getMe(userId);
    emit(state.copyWith(status: state.status, userModel: userFull));
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
    emit(state.copyWith(status: AuthStatus.unautheficated, userModel: UserModel()));
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.refreshToken();
    } catch (e) {
      print('Ошибка logout: $e');
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
      emit(state.copyWith(status: AuthStatus.unautheficated, userModel: UserModel()));
    }
  }

  Future<void> _onRegisterPressed(RegisterPressedEvent event,Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.register));
    } catch (e) {
      print('Ошибка регистрации: $e');
      emit(state.copyWith(status: AuthStatus.unautheficated));
    }
  }

}

