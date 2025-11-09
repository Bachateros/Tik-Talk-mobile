import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';

class HomeEntitie {
  final List<ChatEntitie?> chats;
  final List<ChatWithLastMessageEntitie?> lastMessages;
  final ChatEntitie? selectedChat;
  final String? errorMessage;

  const HomeEntitie({
    this.chats = const [],
    this.lastMessages = const [],
    this.selectedChat,
    this.errorMessage,
  });

  HomeEntitie copyWith({
    List<ChatEntitie?>? chats,
    List<ChatWithLastMessageEntitie?>? lastMessages,
    ChatEntitie? selectedChat,
    String? errorMessage,
  }){
    return HomeEntitie(
      chats: chats ?? this.chats,
      lastMessages: lastMessages ?? this.lastMessages,
      selectedChat: selectedChat ?? this.selectedChat,
      errorMessage: errorMessage ?? this.errorMessage,
      );
  }
}

class ChatWithLastMessageEntitie {
  final ChatEntitie chat;
  final MessageEntitie? lastMessage;

  ChatWithLastMessageEntitie({
    required this.chat,
    this.lastMessage,
  });
}