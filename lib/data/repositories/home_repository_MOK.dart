import 'dart:async';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/home_entitie.dart';
import 'package:tik_talk/domain/entities/messege_entitie.dart';
import 'package:tik_talk/domain/repositories/home_repository.dart';

class MockHomeRepository implements HomeRepository {
  final List<ChatEntitie> _chats = [];
  final List<MessegeEntitie> _messages = [];

  MockHomeRepository() {
    // Добавим тестовые данные
    final now = DateTime.now();
    _chats.addAll([
      ChatEntitie(
        idChat: '1',
        nameChat: 'Flutter Devs',
        descriptionChat: 'Обсуждаем Flutter и Dart',
        isPrivate: true,
        typeChat: ChatType.group,
        createdAt: now,
        updatedAt: now,
      ),
      ChatEntitie(
        idChat: '2',
        nameChat: 'Team Project',
        descriptionChat: 'Рабочий чат команды',
        isPrivate: true,
        typeChat: ChatType.group,
        createdAt: now,
        updatedAt: now,
      ),
    ]);

    _messages.addAll([
      MessegeEntitie(
        idMessege: 'm1',
        idChat: '1',
        idUser: 'u1',
        content: 'Всем привет! Кто пробовал Bloc 9.0?',
        createdAt: now.subtract(const Duration(minutes: 5)), 
        typeMessage: MessegeType.text,
      ),
      MessegeEntitie(
        idMessege: 'm2',
        idChat: '2',
        idUser: 'u2',
        content: 'Обновил репозиторий, гляньте',
        createdAt: now.subtract(const Duration(minutes: 2)),
        typeMessage: MessegeType.text,
      ),
    ]);
  }

  @override
  Future<List<ChatEntitie>> getChats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _chats;
  }


  @override
  Future<List<ChatWithLastMessegeEntitie?>> getLastMessages(List<ChatEntitie> chats) async {
    List<ChatWithLastMessegeEntitie> lastMesseges = [];
    for (final chat in chats){
       final chatMessages = _messages.where((m)=> m.idChat == chat.idChat).toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));
       lastMesseges.add(ChatWithLastMessegeEntitie(chat: chat,lastMessege: chatMessages.isEmpty ? null : chatMessages.last));
    }
    return lastMesseges;
  }
}
