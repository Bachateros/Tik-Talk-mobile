import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/message_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/participiant_service_remote_source.dart';
import 'package:tik_talk/data/DTO/chat_DTO.dart';
import 'package:tik_talk/data/DTO/messege_DTO.dart';
import 'package:tik_talk/data/DTO/participant_DTO.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository{
  final ChatsServiceRemoteSource chatsService;
  final MessageServiceRemoteSource messageService;
  final ParticipiantServiceRemoteSource participantService;

  ChatRepositoryImpl({
    required this.chatsService,
    required this.messageService,
    required this.participantService,
  });
  
  @override
  Future<ChatEntitie> createChat(ChatEntitie chat, List<ParticipantEntitie?> participantsList) {
    // TODO: implement createChat
    throw UnimplementedError();
  }
  
  @override
  Future<void> deleteChat(String chatId) {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }
  
  @override
  Future<ChatEntitie> getChat(String chatId) {
    // TODO: implement getChat
    throw UnimplementedError();
  }
  
  @override
  Future<List<ParticipantEntitie?>> getChatParticipants(String chatId) {
    // TODO: implement getChatParticipants
    throw UnimplementedError();
  }
  
  @override
  Future<List<MessageEntitie?>> getMessage(String chatId) {
    // TODO: implement getMessage
    throw UnimplementedError();
  }
  
  @override
  Future<void> leaveChat(String chatId) {
    // TODO: implement leaveChat
    throw UnimplementedError();
  }
  
  @override
  Future<void> sendMessage(MessageEntitie message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
  
  @override
  Future<ChatEntitie> updateChat(ChatEntitie chat) {
    // TODO: implement updateChat
    throw UnimplementedError();
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