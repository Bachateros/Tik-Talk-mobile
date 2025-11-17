import 'package:tik_talk/data/datasources/local/chats_dao.dart';
import 'package:tik_talk/data/datasources/local/participants_dao.dart';
import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/data/mapers/chat_mapper.dart';
import 'package:tik_talk/data/mapers/participant_mapper.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/repositories/create_chat_repository.dart';

class CreateChatRepositoryImpl extends CreateChatRepository{
  final ChatsDao chatsDao;
  final ParticipantsDao participantsDao;
  final ParticipantMapper participantMapper;
  final ChatsServiceRemoteSource chatsService;
  final ChatMapper chatMapper;

  CreateChatRepositoryImpl({
    required this.participantMapper,
    required this.chatsDao,
    required this.participantsDao,
    required this.chatsService,
    required this.chatMapper
  });

 @override
  Future<String?> createChat(
      ChatEntitie chat,
      List<ParticipantEntitie?> participantsList
  ) async {

    final chatDTO = chatMapper.fromEntity(chat);
    final partDTO = participantsList
        .map((e) => participantMapper.fromEntity(e!))
        .toList();

    try {
      final newIdChat = await chatsService.createChat(chatDTO, partDTO);
      if (newIdChat != null || newIdChat != ''){
        return newIdChat;
      }
      else{
        throw('Ошибка в реопзитории создания чата, вернулся null от сервиса');
      }
    } catch (e) {
      throw Exception("Ошибка createChat: $e");
    }
  }
}