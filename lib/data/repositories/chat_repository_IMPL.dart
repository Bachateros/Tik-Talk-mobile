import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/message_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/participiant_service_remote_source.dart';
import 'package:tik_talk/data/models/chat_model.dart';
import 'package:tik_talk/data/models/messege_model.dart';
import 'package:tik_talk/data/models/participant_model.dart';
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
  Future<ChatEntitie> createChat(ChatEntitie chat, List<ParticipantEntitie?> participants) async {
    final List<Map<String, String>> participantsList = participants
    .map((part) => {'id': part!.userId})
    .toList();
    
    final chatId = await chatsService.createChat(
      name: chat.nameChat,
      description: chat.descriptionChat,
      type: chat.typeChat,
      avatarUrl: chat.avatarUrl,
      isPrivate: chat.isPrivate,
      participants: participantsList,
    );
    return chat.copyWith(idChat: chatId);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await chatsService.deleteChat(chatId);
  }

  @override
  Future<ChatEntitie> updateChat(ChatEntitie chat) async {
    await chatsService.updateChat(
      chatId: chat.idChat,
      name: chat.nameChat,
      description: chat.descriptionChat,
      avatarUrl: chat.avatarUrl,
      isPrivate: chat.isPrivate,
    );
    return chat;
  }

  @override
  Future<ChatEntitie> getChat(String chatId) async {
    final data = await chatsService.getChatDetails(chatId);
    return ChatModel.fromJson(data);
  }

  @override
  Future<List<ParticipantEntitie?>> getChatParticipants(String chatId) async {
    final list = await participantService.getChatParticipants(chatId);

    
    return list.map((e) => ParticipantModel.fromJson(e)).toList();
  }

  @override
  Future<List<MessageEntitie?>> getMessage(String chatId) async {
    final list = await messageService.getChatMessages(chatId: chatId);
    return list.map((e) => MessageModel.fromJson(e)).toList();
  }

  @override
  Future<MessageEntitie> sendMessage(MessageEntitie message) async {
    final idMsg = await messageService.sendMessage(
      chatId: message.idChat,
      content: message.content,
      type: message.typeMessage,
      userId: message.idUser,
      replyToId: message.replyToId,
      fileUrl: message.fileUrl,
      fileName: message.fileName,
      fileSize: message.fileSize,
      mimeType: message.mimeType,
    );
    final MessageModel msg = MessageModel(idChat: idMsg, idUser: message.idUser, content: message.content, typeMessage: message.typeMessage, createdAt: message.createdAt);
    return msg;
  }
  
  @override
  Future<void> leaveChat(String chatId) async {
    await participantService.leaveChat(chatId);
  }
  
}