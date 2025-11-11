import 'package:drift/drift.dart';
import 'package:tik_talk/data/DTO/chat_DTO.dart';
import '../db/app_db.dart';

part 'chats_dao.g.dart';

@DriftAccessor(tables: [Chats])
class ChatsDao extends DatabaseAccessor<AppDb> with _$ChatsDaoMixin {
  ChatsDao(AppDb db) : super(db);

    Future<void> insertOrUpdate(ChatDTO chatDTO) async {
    final now = DateTime.now();
    await into(chats).insertOnConflictUpdate(
      ChatsCompanion(
        id: Value(chatDTO.id),
        name: Value(chatDTO.name),
        description: Value(chatDTO.description),
        type: Value(chatDTO.type),
        createdBy: Value(chatDTO.createdBy),
        avatarUrl: Value(chatDTO.avatarUrl),
        maxMembers: Value(chatDTO.maxMembers ?? 1000),
        lastActivityAt: Value(chatDTO.lastActivityAt),
        isPrivate: Value(chatDTO.isPrivate),
        isDeleted: Value(chatDTO.isDeleted),
        createdAt: Value(chatDTO.createdAt),
        updatedAt: Value(chatDTO.updatedAt ?? now),
        deletedAt: Value(chatDTO.deletedAt),
      ),
    );
  }
  // Добавить чаты
  Future<void> insertChats(List<ChatsCompanion> entries) async {
    await batch((b) => b.insertAllOnConflictUpdate(chats, entries));
  }

  // Обновить данные о чате (универсально)
  Future<int> updateChat(String id, {String? name, String? description, String? avatarUrl}) async {
    return (update(chats)..where((c) => c.id.equals(id))).write(
      ChatsCompanion(
        name: name != null ? Value(name) : const Value.absent(), 
        description: description != null ? Value(description) : const Value.absent(),
        avatarUrl: avatarUrl != null ? Value(avatarUrl) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Получить ID всех чатов
  Future<List<String?>> getAllChatIds() async {
    final q = await selectOnly(chats)..addColumns([chats.id]);
    final rows = await q.get();
    return rows.map((r) => r.read(chats.id)).toList();
  }

  // Получить все чаты
  Future<List<Chat>> getAllChats() => select(chats).get();

  // Пометить чат удалённым (isPrivate -> true, или добавь поле isDeleted)
  Future<int> markChatDeleted(String id) async {
    return (update(chats)..where((c) => c.id.equals(id))).write(
      ChatsCompanion(description: const Value('[deleted]'), updatedAt: Value(DateTime.now())),
    );
  }
}
