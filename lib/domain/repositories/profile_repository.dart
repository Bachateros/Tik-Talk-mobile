import 'package:tik_talk/domain/entities/user_entitie.dart';

abstract class ProfileRepository {
  Future<UserEntity> getUser(String userId);
}