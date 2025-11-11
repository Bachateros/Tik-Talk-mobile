import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/message_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/participiant_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/user_service_remote_source.dart';
import 'package:tik_talk/data/DTO/chat_DTO.dart';
import 'package:tik_talk/data/DTO/messege_DTO.dart';
import 'package:tik_talk/data/DTO/participant_DTO.dart';
import 'package:tik_talk/data/DTO/user_DTO.dart';
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
  
  @override
  Future<List<ChatEntitie?>> getChats() {
    // TODO: implement getChats
    throw UnimplementedError();
  }
  
  @override
  Future<List<ChatWithLastMessageEntitie?>> getLastMessages(List<ChatEntitie?> chats) {
    // TODO: implement getLastMessages
    throw UnimplementedError();
  }
  
  @override
  Future<List<ParticipantEntitie?>> getParticipant(List<ChatEntitie?> chats) {
    // TODO: implement getParticipant
    throw UnimplementedError();
  }
  
  @override
  Future<List<UserEntity?>> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

}

// final List<ChatEntitie?> _chats = [];
// final List<MessageEntitie?> _messages = [];
// final List<ParticipantEntitie?> _participiants = [];
// final List<UserEntity?> _users = [];

// @override
// Future<List<ChatWithLastMessageEntitie?>> getLastMessages(List<ChatEntitie?> chats) async {
//   final List<ChatWithLastMessageEntitie?> list = [];

//   for (final chat in chats) {
//     if (chat == null) {
//       list.add(null);
//       continue;
//     }

//     try {
//       final messages = await messageService.getChatMessages(chatId: chat.idChat);
//       final lastMessageData = messages.isNotEmpty ? messages.last : null;

//       MessageEntitie? lastMessage;
//       if (lastMessageData != null) {
//         try {
//           final messageMap  = Map<String, dynamic>.from(lastMessageData);
//           final message = MessageModel.fromJson(messageMap);
//           lastMessage = message;
//           _messages.add(message);
//         } catch (e) {
//           print('Ошибка преобразования сообщения для чата ${chat.idChat}: $e');
//           _messages.add(null);
//         }
//       }

//       list.add(ChatWithLastMessageEntitie(chat: chat, lastMessage: lastMessage));
//     } catch (e) {
//       print('Ошибка получения сообщений для чата ${chat.idChat}: $e');
//       list.add(ChatWithLastMessageEntitie(chat: chat, lastMessage: null));
//     }
//   }

//   return list;
// }


// @override
// Future<List<ParticipantEntitie?>> getParticipant(List<ChatEntitie?> chats) async {
//   try {
//     final List<ParticipantEntitie?> allParticipants = [];

//     for (final chat in chats) {
//       if (chat == null) continue;
      
//       try {
//         final participantsData = await participantService.getChatParticipants(chat.idChat);
        
//         for (final participantData in participantsData) {
//           try {
//             final Map<String, dynamic> participantMap = Map<String, dynamic>.from(participantData);
//             final participant = ParticipantModel.fromJson(participantMap);
//             allParticipants.add(participant);
//             _participiants.add(participant);
//           } catch (e) {
//             print('Ошибка преобразования участника: $e');
//             allParticipants.add(null);
//             _participiants.add(null);
//           }
//         }
//       } catch (e) {
//         print('Ошибка получения участников для чата ${chat.idChat}: $e');
//       }
//     }

//     return allParticipants;
//   } catch (e) {
//     print('Ошибка при загрузке участников: $e');
//     return _participiants.isNotEmpty ? _participiants : [];
//   }
// }

// @override
// Future<List<ChatEntitie?>> getChats() async {
//   try {
//     final List<dynamic> chatsData = await chatService.getUserChats();
//     final List<ChatEntitie?> chatsList = [];
    
//     for (final chatData in chatsData) {
//       try {
//         final Map<String, dynamic> chatMap = Map<String, dynamic>.from(chatData);
        
//         final chat = ChatModel.fromJson(chatMap);
//         chatsList.add(chat);
//         _chats.add(chat);
//       } catch (e) {
//         print('Ошибка парсинга чата: $e');
//         chatsList.add(null);
//         _chats.add(null);
//       }
//     }
    
//     return chatsList;
//   } catch (e) {
//     print('Ошибка получения чатов: $e');
//     return _chats.isNotEmpty ? _chats : [];
//   }
// }

// @override
// Future<List<UserEntity?>> getUsers() async {
//   try {
//     final usersData = await userService.getAllUsers();
//     final List<UserEntity?> usersList = [];

//     for (final userData in usersData) {
//       try {
//         final Map<String, dynamic> userMap = Map<String, dynamic>.from(userData);
//         final user = UserModel.fromJson(userMap);
//         final profileDate = await userService.getUserProfile(user.userId);
//         final profile = UserModel.fromJson(profileDate);
//         user.copyWith(aboutMe:profile.aboutMe ,avatarUrl:profile.avatarUrl ,birthdayDate: profile.birthdayDate );
//         usersList.add(user);
//         _users.add(user);
//       } catch (e) {
//         print('Ошибка преобразования пользователя: $e');
//         usersList.add(null);
//         _users.add(null);
//       }
//     }
//     return usersList;
//   } catch (e) {
//     print('Ошибка при загрузке пользователей: $e');
//     return _users.isNotEmpty ? _users : [];
//   }
// }