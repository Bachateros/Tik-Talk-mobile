part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {} // Проверка токенов при запуске

class LoginEvent extends AuthEvent {
  final String tgUsername;
  final String password;
  LoginEvent(this.tgUsername, this.password);
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String surname;
  final String tgUsername;
  final String password;
  RegisterEvent(this.name, this.surname, this.tgUsername, this.password);
}

class VerifyEvent extends AuthEvent {
  final String code;
  VerifyEvent(this.code);
}

class RegisterPressedEvent extends AuthEvent{}

class LogoutEvent extends AuthEvent {}

class RefreshTokenEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}
