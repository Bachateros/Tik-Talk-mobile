import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/data/models/user_model.dart';
import 'package:tik_talk/domain/entities/user_entity.dart';
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
    final hasTokens = await repository.hasValidTokens();
    if (hasTokens) {
      emit(state.copyWith(status: AuthStatus.autheficated));
    } else {
      emit(state.copyWith(status: AuthStatus.unautheficated));
    }
  } catch (e) {
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
        emit(state.copyWith(status: AuthStatus.verify, userModel: user));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.unknown,userModel: UserEntity(), errorMessage:  'Ошибка входа: $e'));
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
      if (user.userId != null) {
        emit(state.copyWith(status: AuthStatus.verify,userModel: user));
      } else {
        emit(state.copyWith(status: AuthStatus.unautheficated));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.unknown,errorMessage: 'Ошибка регистрации: $e'));
    }
  }

  Future<void> _onVerify(VerifyEvent event, Emitter<AuthState> emit) async {
    try {
      final user = await repository.verify(event.userId, event.code);
      emit(state.copyWith(status: AuthStatus.autheficated,userModel: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.unknown,errorMessage: 'Ошибка верификации: $e'));
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
      emit(state.copyWith(status: AuthStatus.unautheficated));
    }
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    final hasTokens = await repository.hasValidTokens();
    if (hasTokens) {
      emit(state.copyWith(status: AuthStatus.autheficated));
    } else {
      emit(state.copyWith(status: AuthStatus.unautheficated, userModel: UserModel()));
    }
  }

  Future<void> _onRegisterPressed(RegisterPressedEvent event,Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AuthStatus.register));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.unautheficated));
    }
  }
}

