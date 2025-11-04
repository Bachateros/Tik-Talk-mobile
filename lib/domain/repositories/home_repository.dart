import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/home_entitie.dart';

abstract class HomeRepository {
  Future<List<ChatEntitie>> getChats();
  Future<List<ChatWithLastMessegeEntitie?>> getLastMessages(List<ChatEntitie> chats);
}