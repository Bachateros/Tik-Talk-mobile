import 'package:tik_talk/data/datasources/local/chats_dao.dart';
import 'package:tik_talk/data/datasources/local/participants_dao.dart';
import 'package:tik_talk/data/datasources/remote/chats_service_remote_source.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/repositories/create_chat_repository.dart';

class CreateChatRepositoryImpl extends CreateChatRepository{
  final ChatsDao chatsDao;
  final ParticipantsDao participantsDao;
  final ChatsServiceRemoteSource chatsService;

  CreateChatRepositoryImpl({
    required this.chatsDao,
    required this.participantsDao,
    required this.chatsService,
  });

  @override
  Future<ChatEntitie> createChat(
    ChatEntitie chat,
    List<ParticipantEntitie?> participantsList,
  ) async {
    // TODO: пока пусто, потом реализуем локально и через сервер
    throw UnimplementedError();
  }
}