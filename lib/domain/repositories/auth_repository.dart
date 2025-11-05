import 'package:tik_talk/domain/entities/user_entitie.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String tgUsername, String password);
  Future<UserEntity> register(String surname, String name, String tgUsername, String password);
  Future<UserEntity> verify(String userId, String code);
  Future<void> logout();          
  Future<UserEntity?> refreshToken();
  Future<String?> hasValidTokens(); 
  Future<UserEntity> initDB();
  Future<UserEntity> getMe(String id);
}