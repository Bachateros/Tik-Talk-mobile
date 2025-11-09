import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/message_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/participiant_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/user_service_remote_source.dart';
import 'package:tik_talk/data/models/chat_model.dart';
import 'package:tik_talk/data/models/messege_model.dart';
import 'package:tik_talk/data/models/participant_model.dart';
import 'package:tik_talk/data/models/user_model.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/home_entitie.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/home_repository.dart';


class HomeRepositoryImpl extends HomeRepository {
  final ChatsServiceRemoteSource chatService;
  final UserServiceRemoteSource userService;
  final ParticipiantServiceRemoteSource participantService;
  final MessageServiceRemoteSource messageService;

  

  HomeRepositoryImpl({
    required this.chatService,
    required this.userService,
    required this.participantService,
    required this.messageService,
  });
final List<ChatEntitie?> _chats = [];
final List<MessageEntitie?> _messages = [];
final List<ParticipantEntitie?> _participiants = [];
final List<UserEntity?> _users = [];

@override
Future<List<ChatWithLastMessageEntitie?>> getLastMessages(List<ChatEntitie?> chats) async {
  final List<ChatWithLastMessageEntitie?> list = [];

  for (final chat in chats) {
    if (chat == null) {
      list.add(null);
      continue;
    }

    try {
      final messages = await messageService.getChatMessages(chatId: chat.idChat);
      final lastMessageData = messages.isNotEmpty ? messages.last : null;

      MessageEntitie? lastMessage;
      if (lastMessageData != null) {
        try {
          final messageMap  = Map<String, dynamic>.from(lastMessageData);
          final message = MessageModel.fromJson(messageMap);
          lastMessage = message;
          _messages.add(message);
        } catch (e) {
          print('Ошибка преобразования сообщения для чата ${chat.idChat}: $e');
          _messages.add(null);
        }
      }

      list.add(ChatWithLastMessageEntitie(chat: chat, lastMessage: lastMessage));
    } catch (e) {
      print('Ошибка получения сообщений для чата ${chat.idChat}: $e');
      list.add(ChatWithLastMessageEntitie(chat: chat, lastMessage: null));
    }
  }

  return list;
}


@override
Future<List<ParticipantEntitie?>> getParticipant(List<ChatEntitie?> chats) async {
  try {
    final List<ParticipantEntitie?> allParticipants = [];

    for (final chat in chats) {
      if (chat == null) continue;
      
      try {
        final participantsData = await participantService.getChatParticipants(chat.idChat);
        
        for (final participantData in participantsData) {
          try {
            final Map<String, dynamic> participantMap = Map<String, dynamic>.from(participantData);
            final participant = ParticipantModel.fromJson(participantMap);
            allParticipants.add(participant);
            _participiants.add(participant);
          } catch (e) {
            print('Ошибка преобразования участника: $e');
            allParticipants.add(null);
            _participiants.add(null);
          }
        }
      } catch (e) {
        print('Ошибка получения участников для чата ${chat.idChat}: $e');
      }
    }

    return allParticipants;
  } catch (e) {
    print('Ошибка при загрузке участников: $e');
    return _participiants.isNotEmpty ? _participiants : [];
  }
}

@override
Future<List<ChatEntitie?>> getChats() async {
  try {
    final List<dynamic> chatsData = await chatService.getUserChats();
    final List<ChatEntitie?> chatsList = [];
    
    for (final chatData in chatsData) {
      try {
        final Map<String, dynamic> chatMap = Map<String, dynamic>.from(chatData);
        
        final chat = ChatModel.fromJson(chatMap);
        chatsList.add(chat);
        _chats.add(chat);
      } catch (e) {
        print('Ошибка парсинга чата: $e');
        chatsList.add(null);
        _chats.add(null);
      }
    }
    
    return chatsList;
  } catch (e) {
    print('Ошибка получения чатов: $e');
    return _chats.isNotEmpty ? _chats : [];
  }
}

@override
Future<List<UserEntity?>> getUsers() async {
  try {
    final usersData = await userService.getAllUsers();
    final List<UserEntity?> usersList = [];

    for (final userData in usersData) {
      try {
        final Map<String, dynamic> userMap = Map<String, dynamic>.from(userData);
        final user = UserModel.fromJson(userMap);
        final profileDate = await userService.getUserProfile(user.userId);
        usersList.add(user);
        _users.add(user);
      } catch (e) {
        print('Ошибка преобразования пользователя: $e');
        usersList.add(null);
        _users.add(null);
      }
    }
    return usersList;
  } catch (e) {
    print('Ошибка при загрузке пользователей: $e');
    return _users.isNotEmpty ? _users : [];
  }
}

// Дополнительные методы для работы с хранилищами
List<ChatEntitie?> get cachedChats => List.from(_chats);
List<MessageEntitie?> get cachedMessages => List.from(_messages);
List<ParticipantEntitie?> get cachedParticipants => List.from(_participiants);
List<UserEntity?> get cachedUsers => List.from(_users);

// Методы для получения только не-null элементов
List<ChatEntitie> get cachedChatsNotNull => _chats.whereType<ChatEntitie>().toList();
List<MessageEntitie> get cachedMessagesNotNull => _messages.whereType<MessageEntitie>().toList();
List<ParticipantEntitie> get cachedParticipantsNotNull => _participiants.whereType<ParticipantEntitie>().toList();
List<UserEntity> get cachedUsersNotNull => _users.whereType<UserEntity>().toList();

// Методы для очистки хранилищ
void clearChatsCache() => _chats.clear();
void clearMessagesCache() => _messages.clear();
void clearParticipantsCache() => _participiants.clear();
void clearUsersCache() => _users.clear();

// Метод для отладки
void printDebugInfo() {
  print('''
DEBUG INFO:
Chats: ${_chats.length} (${_chats.whereType<ChatEntitie>().length} not null)
Users: ${_users.length} (${_users.whereType<UserEntity>().length} not null) 
Messages: ${_messages.length} (${_messages.whereType<MessageEntitie>().length} not null)
Participants: ${_participiants.length} (${_participiants.whereType<ParticipantEntitie>().length} not null)
''');
}
}