import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/home_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';

abstract class HomeRepository {
  Future<List<ChatEntitie?>> getChats();
  Future<List<ChatWithLastMessageEntitie?>> getLastMessages(List<ChatEntitie?> chats);
  Future<List<ParticipantEntitie?>>getParticipant(List<ChatEntitie?> chats);
  Future<List<UserEntity?>>getUsers();
}