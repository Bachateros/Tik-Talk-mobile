import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';

abstract class CreateChatRepository {
  Future<String?> createChat(ChatEntitie chat,List<ParticipantEntitie?> participantsList);

}
