abstract class AuthState {}

class AuthInitial extends AuthState {}           // при старте приложения
class LoginState extends AuthState {}            // экран логина
class RegisterState extends AuthState {}         // экран регистрации
class VerifyState extends AuthState {            // экран верификации
  final int userId;
  VerifyState(this.userId);
}
class AuthenticatedState extends AuthState {}    // вход выполнен
class LogoutState extends AuthState {}           // токенов нет
class AuthErrorState extends AuthState {         // универсальное состояние ошибки
  final String message;
  AuthErrorState(this.message);
}


