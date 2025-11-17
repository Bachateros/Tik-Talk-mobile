import 'package:tik_talk/data/DTO/messege_DTO.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/data/datasources/local/chats_dao.dart';
import 'package:tik_talk/data/datasources/local/messages_dao.dart';
import 'package:tik_talk/data/datasources/local/participants_dao.dart';
import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/message_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/participiant_service_remote_source.dart';
import 'package:tik_talk/data/datasources/remote/sync_service_remote_data_service.dart';
import 'package:tik_talk/data/mapers/chat_mapper.dart';
import 'package:tik_talk/data/mapers/message_mapper.dart';
import 'package:tik_talk/data/mapers/participant_mapper.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository{
  final ParticipiantServiceRemoteSource participantService;
  final MessageServiceRemoteSource messageService;
  final ChatsServiceRemoteSource chatsService;

  final ParticipantMapper participantMapper;
  final MessageMapper messageMapper;
  final ChatMapper chatMapper;

  final ParticipantsDao participantsDao;
  final MessagesDao messagesDao;
  final ChatsDao chatsDao;
  
  final SyncServiceRemoteDataService syncService;

  ChatRepositoryImpl({
    required this.chatsDao,
    required this.chatsService,
    required this.chatMapper,

    required this.participantsDao,
    required this.participantService,
    required this.participantMapper,

    required this.messagesDao,
    required this.messageService,
    required this.messageMapper,

    required this.syncService,
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
// удаление, выход
  /// Пометить чат удалённым
  @override
  Future<void> deleteChat(String chatId) async {
    final resp = await chatsService.deleteChat(chatId);
    if(resp){
      
    } else{
      throw('ошибка удаления чата в репозитории ChatRepo');
    }
  }

  /// Выйти из чата (локально можно просто удалить участника)
  @override
  Future<void> leaveChat(String chatId) async {
    try {
      // 1) попросить сервер убрать участника / вернуть DTO участника
      await participantService.leaveChat(chatId);

    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception('Сессия истекла. Авторизуйтесь заново.');
      }
      throw Exception('Ошибка API [${e.statusCode}]: ${e.body}');
    } catch (e) {
      throw Exception('Сетевая ошибка: $e');
    }
  }

//облновление
  /// Обновить чат (локально и на сервере) — возвращаем обновленную entity
  @override
  Future<ChatEntitie> updateChat(ChatEntitie chat) async {
    try {
      final chatDTO = chatMapper.fromEntity(chat);
      final resp = await chatsService.updateChat(chatDTO);
      // конвертируем в DTO
      // final ChatDTO requestDto = chatMapper.fromEntity(chat);

      //отправляем на сервер, ждём обновлённый DTO
      // final ChatDTO updatedDto = await chatsService.updateChat(requestDto);

      // // сохраняем в БД (insertOrUpdate)
      // await chatsDao.insertOrUpdate(updatedDto);

      // // 4) возвращаем Entity из DTO
      return chatMapper.toEntity(resp);
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception('Сессия истекла. Авторизуйтесь заново.');
      }
      throw Exception('Ошибка API [${e.statusCode}]: ${e.body}');
    } catch (e) {
      throw Exception('Сетевая ошибка: $e');
    }
  }

/// Отправить сообщение (локально и на сервере)
  @override
  Future<void> sendMessage(MessageEntitie message) async {
      final MessageDTO requestDto = messageMapper.fromEntity(message);

      messageService.sendMessage(requestDto);
  }

  @override
  Future<bool> removeFromChat(String chatId, String userId) async {
    try{
      final resp = await participantService.removeParticipant(chatId: chatId, userId: userId);
      if(resp){
        return true;
      }else{
        return false;
      }
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception('Сессия истекла. Авторизуйтесь заново.');
      }
      throw Exception('Ошибка API [${e.statusCode}]: ${e.body}');
    } catch (e) {
      throw Exception('Сетевая ошибка: $e');
    }
  }
}
