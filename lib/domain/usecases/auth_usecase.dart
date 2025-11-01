import 'package:tik_talk/domain/entities/user_entity.dart';
import 'package:tik_talk/domain/repositories/auth_repository.dart';

class LoginUser{
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<UserEntity> execute (String tgUsername,String password){
    return repository.login(tgUsername, password);
  }
}

class RegisterUser{
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<UserEntity> execute(String surname, String name, String tgUsername, String password) {
    return repository.register(surname, name, tgUsername, password);
  }
}

class VerifyUser{
  final AuthRepository repository;

  VerifyUser(this.repository);

  Future<UserEntity> execute(int userId, String code) {
    return repository.verify(userId, code);
  }
}

class LogoutUser{
  final AuthRepository repository;

  LogoutUser(this.repository);

  Future<void> execute(){
    return repository.logout();
  }
}

class RefreshToken{
  final AuthRepository repository;

  RefreshToken(this.repository);

  Future<UserEntity?> execute(){
    return repository.refreshToken();
  }
}