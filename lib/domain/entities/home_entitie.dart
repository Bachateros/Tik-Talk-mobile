import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/messege_entitie.dart';

class HomeEntitie {
  final List<ChatEntitie?> chats;
  final List<ChatWithLastMessegeEntitie?> lastMesseges;
  final ChatEntitie? selectedChat;
  final String? errorMessage;

  const HomeEntitie({
    this.chats = const [],
    this.lastMesseges = const [],
    this.selectedChat,
    this.errorMessage,
  });

  HomeEntitie copyWith({
    List<ChatEntitie?>? chats,
    List<ChatWithLastMessegeEntitie?>? lastMesseges,
    ChatEntitie? selectedChat,
    String? errorMessage,
  }){
    return HomeEntitie(
      chats: chats ?? this.chats,
      lastMesseges: lastMesseges ?? this.lastMesseges,
      selectedChat: selectedChat ?? this.selectedChat,
      errorMessage: errorMessage ?? this.errorMessage,
      );
  }
}

class ChatWithLastMessegeEntitie {
  final ChatEntitie chat;
  final MessegeEntitie? lastMessege;

  ChatWithLastMessegeEntitie({
    required this.chat,
    this.lastMessege,
  });
}