import 'package:tik_talk/domain/entities/last_message_chat_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';

abstract class HomeRepository {
    Future<List<ChatWithLastMessageEntitie?>> getLastMessages(String userId) ;
  Future<List<UserEntity?>> getContacts(String myUserId);
  Future<UserEntity> getMy(String userId) ;
  Future<List<UserEntity?>>getAllUsers();
}