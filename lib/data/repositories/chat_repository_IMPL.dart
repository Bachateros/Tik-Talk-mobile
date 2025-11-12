import 'package:tik_talk/data/datasources/local/chats_dao.dart';
import 'package:tik_talk/data/datasources/local/messages_dao.dart';
import 'package:tik_talk/data/datasources/local/participants_dao.dart';
import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/message_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/participiant_service_remote_source.dart';
import 'package:tik_talk/data/mapers/chat_mapper.dart';
import 'package:tik_talk/data/mapers/message_mapper.dart';
import 'package:tik_talk/data/mapers/participant_mapper.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository{
  final ChatsDao chatsDao;
  final MessagesDao messagesDao;
  final ParticipantsDao participantsDao;

  final ChatsServiceRemoteSource chatsService;
  final MessageServiceRemoteSource messageService;
  final ParticipiantServiceRemoteSource participantService;

  ChatRepositoryImpl({
    required this.chatsDao,
    required this.messagesDao,
    required this.participantsDao,
    required this.chatsService,
    required this.messageService,
    required this.participantService,
  });

  /// Получить информацию о чате
  @override
  Future<ChatEntitie> getChat(String chatId) async {
    final chat = await (chatsDao.select(chatsDao.chats)
          ..where((tbl) => tbl.id.equals(chatId)))
        .getSingle();

    // Преобразуем Chat -> ChatDTO -> Entity
    final chatDTO = ChatMapper().toDTO(chat);
    final entity = ChatMapper().toEntity(chatDTO);
    return entity;
  }

  /// Получить всех участников чата
  @override
  Future<List<ParticipantEntitie?>> getChatParticipants(String chatId) async {
    final parts = await participantsDao.getParticipantsByChat(chatId);
    return parts
        .map((e) => ParticipantMapper().toEntity(ParticipantMapper().toDTO(e)))
        .toList();
  }

  /// Получить все сообщения чата
  @override
  Future<List<MessageEntitie?>> getMessage(String chatId) async {
    final msgs = await messagesDao.getMessagesByChat(chatId);
    return msgs
        .map((e) => MessageMapper().toEntity(MessageMapper().toDTO(e)))
        .toList();
  }

  /// Пометить чат удалённым
  @override
  Future<void> deleteChat(String chatId) async {
    // final resp = chatsService.deleteChat(chatId);
    // if (resp==)
    // await chatsDao.markChatDeleted(chatId);
  }

  /// Выйти из чата (локально можно просто удалить участника)
  @override
  Future<void> leaveChat(String chatId) async {
    // TODO: обновить в DAO, что пользователь покинул чат
    // await participantsDao.markParticipantRemoved(currentUserId);
  }

  /// Отправить сообщение (локально)
  @override
  Future<void> sendMessage(MessageEntitie message) async {
    // final dto = MessageMapper().fromEntity(message);
    // final resp = await messageService.sendMessage(dto);
    // if(resp ==){
    //   final model = MessagesCompanion.insert(
    //     id: dto.id,
    //     chatId: dto.chatId,
    //     userId: dto.userId,
    //     content: Value(dto.content),
    //     createdAt: Value(dto.createdAt),
    //   );
    //   await messagesDao.insertMessage(model);
    // }
  }

  /// Обновить чат (локально)
  @override
  Future<ChatEntitie> updateChat(ChatEntitie chat) async {
    // TODO: Реализовать обновление чата в DAO
    // await chatsDao.updateChat(chat.id, name: chat.name);
    return chat;
  }

}

  // @override
  // Future<ChatEntitie> createChat(ChatEntitie chat, List<ParticipantEntitie?> participants) async {
  //   final List<Map<String, String>> participantsList = participants
  //   .map((part) => {'id': part!.userId})
  //   .toList();
    
  //   final chatId = await chatsService.createChat(
  //     name: chat.nameChat,
  //     description: chat.descriptionChat,
  //     type: chat.typeChat,
  //     avatarUrl: chat.avatarUrl,
  //     isPrivate: chat.isPrivate,
  //     participants: participantsList,
  //   );
  //   return chat.copyWith(idChat: chatId);
  // }

  // @override
  // Future<void> deleteChat(String chatId) async {
  //   await chatsService.deleteChat(chatId);
  // }

  // @override
  // Future<ChatEntitie> updateChat(ChatEntitie chat) async {
  //   await chatsService.updateChat(
  //     chatId: chat.idChat,
  //     name: chat.nameChat,
  //     description: chat.descriptionChat,
  //     avatarUrl: chat.avatarUrl,
  //     isPrivate: chat.isPrivate,
  //   );
  //   return chat;
  // }

  // @override
  // Future<ChatEntitie> getChat(String chatId) async {
  //   final data = await chatsService.getChatDetails(chatId);
  //   return ChatModel.fromJson(data);
  // }

  // @override
  // Future<List<ParticipantEntitie?>> getChatParticipants(String chatId) async {
  //   final list = await participantService.getChatParticipants(chatId);

    
  //   return list.map((e) => ParticipantModel.fromJson(e)).toList();
  // }

  // @override
  // Future<List<MessageEntitie?>> getMessage(String chatId) async {
  //   final list = await messageService.getChatMessages(chatId: chatId);
  //   return list.map((e) => MessageModel.fromJson(e)).toList();
  // }

  // @override
  // Future<MessageEntitie> sendMessage(MessageEntitie message) async {
  //   final idMsg = await messageService.sendMessage(
  //     chatId: message.idChat,
  //     content: message.content,
  //     type: message.typeMessage,
  //     userId: message.idUser,
  //     replyToId: message.replyToId,
  //     fileUrl: message.fileUrl,
  //     fileName: message.fileName,
  //     fileSize: message.fileSize,
  //     mimeType: message.mimeType,
  //     status: message.status,
  //   );
  //   final MessageModel msg = MessageModel(
  //     idChat: idMsg, 
  //     idUser: message.idUser, 
  //     content: message.content, 
  //     typeMessage: message.typeMessage, 
  //     createdAt: message.createdAt,
  //     status: message.status );
  //   return msg;
  // }
  
  // @override
  // Future<void> leaveChat(String chatId) async {
  //   await participantService.leaveChat(chatId);
  // }