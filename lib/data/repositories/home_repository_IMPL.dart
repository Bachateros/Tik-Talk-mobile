import 'package:tik_talk/data/DTO/chat_DTO.dart';
import 'package:tik_talk/data/datasources/local/chats_dao.dart';
import 'package:tik_talk/data/datasources/local/messages_dao.dart';
import 'package:tik_talk/data/datasources/local/participants_dao.dart';
import 'package:tik_talk/data/datasources/local/users_dao.dart';
import 'package:tik_talk/data/DTO/messege_DTO.dart';
import 'package:tik_talk/data/DTO/user_DTO.dart';
import 'package:tik_talk/data/mapers/chat_mapper.dart';
import 'package:tik_talk/data/mapers/message_mapper.dart';
import 'package:tik_talk/data/mapers/participant_mapper.dart';
import 'package:tik_talk/data/mapers/user_mapper.dart';
import 'package:tik_talk/domain/entities/last_message_chat_entitie.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/home_repository.dart';


class HomeRepositoryImpl extends HomeRepository {
  final ChatsDao chatsDao;
  final MessagesDao messagesDao;
  final ParticipantsDao participantsDao;
  final UsersDao usersDao;

  final ChatMapper chatMapper = ChatMapper();
  final MessageMapper messageMapper = MessageMapper();
  final ParticipantMapper participantMapper = ParticipantMapper();
  final UserMapper userMapper = UserMapper();

  HomeRepositoryImpl({
    required this.chatsDao,
    required this.messagesDao,
    required this.participantsDao,
    required this.usersDao,
  });

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final userDtos = await usersDao.getAllUsers();
    return userDtos
        .map((u) => userMapper.toEntity(
              UserDTO(
                id: u.id,
                name: u.name,
                surname: u.surname,
                tgname: u.tgname,
                bio: u.bio,
                avatarUrl: u.avatarUrl,
                isDeleted: u.isDeleted,
                createdAt: u.createdAt,
                updatedAt: u.updatedAt,
                deletedAt: u.deletedAt,
              ),
            ))
        .toList();
  }


  @override
  Future<List<ChatWithLastMessageEntitie?>> getLastMessages(String userId) async {
    final List<ChatWithLastMessageEntitie?> result = [];
    final chats = await chatsDao.getAllChats();
    for (final chat in chats) {

      final msgDto = await messagesDao.getLastMessage(chat.id);
      MessageEntitie? lastMsgEntity;
      if (msgDto != null) {
        lastMsgEntity = messageMapper.toEntity(
          MessageDTO(
            id: msgDto.id,
            chatId: msgDto.chatId,
            userId: msgDto.userId,
            content: msgDto.content,
            type: msgDto.type,
            createdAt: msgDto.createdAt,
            updatedAt: msgDto.updatedAt,
            deletedAt: msgDto.deletedAt,
            clientId: msgDto.clientId,
            isDeleted: msgDto.isDeleted,
          ),
        );
      }
      final dto = ChatDTO(
        id: chat.id,
        name: chat.name,
        description: chat.description,
        type: chat.type,
        createdBy: chat.createdBy,
        avatarUrl: chat.avatarUrl,
        maxMembers: chat.maxMembers,
        lastActivityAt: chat.lastActivityAt,
        isPrivate: chat.isPrivate,
        isDeleted: chat.isDeleted,
        createdAt: chat.createdAt,
        updatedAt: chat.updatedAt,
        deletedAt: chat.deletedAt,
      );
      if (dto.type == 'direct'){
        final contactId = await participantsDao.getDirectContact(dto.id,userId);
        result.add(ChatWithLastMessageEntitie(chat: chatMapper.toEntity(dto), lastMessage: lastMsgEntity, contactId: contactId));
      } else {
        result.add(ChatWithLastMessageEntitie(chat: chatMapper.toEntity(dto), lastMessage: lastMsgEntity));
      }
    }

    return result;
  }

  @override
  Future<List<UserEntity?>> getContacts(String myUserId) async {
    // Находим всех участников, у которых есть общие чаты с текущим пользователем
    final allParticipants = await participantsDao.getDistinctUserIds();

    final Set<String> contactIds = {};
    for (final id in allParticipants) {
      if (id != myUserId) contactIds.add(id);
    }

    final users = await usersDao.getUsersByIds(contactIds.toList());
    return users
        .map((u) => userMapper.toEntity(
              UserDTO(
                id: u.id,
                name: u.name,
                surname: u.surname,
                tgname: u.tgname,
                bio: u.bio,
                avatarUrl: u.avatarUrl,
                isDeleted: u.isDeleted,
                createdAt: u.createdAt,
                updatedAt: u.updatedAt,
                deletedAt: u.deletedAt,
              ),
            ))
        .toList();
  }

  @override
  Future<UserEntity> getMy(String userId) async {
    final userDto = await usersDao.getUserById(userId);
    if (userDto == null) throw Exception("User not found");

    final dto = UserDTO(
      id: userDto.id,
      name: userDto.name,
      surname: userDto.surname,
      tgname: userDto.tgname,
      bio: userDto.bio,
      avatarUrl: userDto.avatarUrl,
      isDeleted: userDto.isDeleted,
      createdAt: userDto.createdAt,
      updatedAt: userDto.updatedAt,
      deletedAt: userDto.deletedAt,
    );

    return userMapper.toEntity(dto);
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