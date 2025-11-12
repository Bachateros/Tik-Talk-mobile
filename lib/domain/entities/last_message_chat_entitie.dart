import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';

class ChatWithLastMessageEntitie {
  final ChatEntitie chat;
  final MessageEntitie? lastMessage;
  final String? contactId;

  ChatWithLastMessageEntitie({
    required this.chat,
    this.lastMessage,
    this.contactId,
  });
}