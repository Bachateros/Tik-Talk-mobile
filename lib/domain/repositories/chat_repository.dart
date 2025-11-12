import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';

abstract class ChatRepository {

  Future<ChatEntitie> getChat(String chatId);
  Future<List<ParticipantEntitie?>> getChatParticipants(String chatId);
  Future<void> sendMessage(MessageEntitie message);
  Future<void> leaveChat(String chatId);

  Future<List<MessageEntitie?>> getMessage(String chatId); 

  

  Future<ChatEntitie> updateChat(ChatEntitie chat);
  Future<void> deleteChat(String chatId);
}