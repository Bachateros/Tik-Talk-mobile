import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<VerifyEvent>(_onVerify);
    on<LogoutEvent>(_onLogout);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final hasTokens = await repository.hasValidTokens();
    if (hasTokens) {
      emit(AuthenticatedState());
    } else {
      emit(LoginState());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await repository.login(event.tgUsername, event.password);
      print(user);
      if (user.userId != null){
        emit(VerifyState(user.userId as int));
      }
    } catch (e) {
      emit(AuthErrorState('Ошибка входа: $e'));
      emit(LoginState());
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await repository.register(event.name, event.surname, event.tgUsername, event.password);
      if (user.userId!=null){
        emit(VerifyState(user.userId as int));
      }
      else{
        emit(LoginState());
      }  
    } catch (e) {
      emit(AuthErrorState('Ошибка регистрации: $e'));
      emit(RegisterState());
    }
  }

  Future<void> _onVerify(VerifyEvent event, Emitter<AuthState> emit) async {
    try {
      await repository.verify(event.userId, event.code);
      emit(AuthenticatedState());
    } catch (e) {
      emit(AuthErrorState('Ошибка верификации: $e'));
      emit(VerifyState(event.userId));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await repository.logout();
    emit(LogoutState());
  }

  Future<void> _onRefreshToken(RefreshTokenEvent event, Emitter<AuthState> emit) async {
    try {
      await repository.refreshToken();
    } catch (e) {
      emit(LogoutState());
    }
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final hasTokens = await repository.hasValidTokens();
    if (hasTokens) {
      emit(AuthenticatedState());
    } else {
      emit(LogoutState());
    }
  }
}
