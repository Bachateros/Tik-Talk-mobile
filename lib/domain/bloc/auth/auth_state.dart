part of 'auth_bloc.dart';

class AuthState {
  final AuthStatus status;
  final UserEntity userModel;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.errorMessage,
    required this.userModel,
  });

  UserEntity get user => userModel;
  String? get accesBotLink => userModel.accesBotLink;

  factory AuthState.initial() =>
      AuthState(status: AuthStatus.unknown, userModel: UserEntity());

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    UserEntity? userModel,
  }) => AuthState(
    status: status ?? this.status,
    errorMessage: errorMessage,
    userModel: userModel ?? this.userModel,
  );
}

enum AuthStatus { 
                  unknown, 
                          autheficated, 
                          unautheficated, 
                          failure,//TODO: сделать event все сломалось если потребуется event со всего приложения
                                    register, 
                                    verify, 
                                    registerBotLink,  
                  }

