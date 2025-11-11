import 'package:drift/drift.dart';
import 'package:tik_talk/data/DTO/messege_DTO.dart';
import '../db/app_db.dart';

part 'messages_dao.g.dart';

@DriftAccessor(tables: [Messages])
class MessagesDao extends DatabaseAccessor<AppDb> with _$MessagesDaoMixin {
  MessagesDao(AppDb db) : super(db);


  Future<void> insertOrUpdate(MessageDTO messageDTO) async {
    final now = DateTime.now();
    await into(messages).insertOnConflictUpdate(
      MessagesCompanion(
        id: Value(messageDTO.id),
        chatId: Value(messageDTO.chatId),
        userId: Value(messageDTO.userId),
        content: Value(messageDTO.content),
        type: Value(messageDTO.type ?? 'text'),
        clientId: Value(messageDTO.clientId),
        status: Value(messageDTO.status),
        fileUrl: Value(messageDTO.fileUrl),
        fileName: Value(messageDTO.fileName),
        fileSize: Value(messageDTO.fileSize),
        mimeType: Value(messageDTO.mimeType),
        replyToId: Value(messageDTO.replyToId),
        isDeleted: Value(messageDTO.isDeleted),
        updatedAt: Value(messageDTO.updatedAt ?? now),

      ),
    );
  }

  //проверка на наличие сообщения: если да обновить, если нет добавить
//   Future<void> upsertMessage(Message message) async {
//   final existing = await (select(messages)
//         ..where((tbl) => tbl.id.equals(message.id)))
//       .getSingleOrNull();

//   if (existing != null) {
//     await update(messages).replace(message);
//   } else {
//     await into(messages).insert(message);
//   }
// }
  // Добавить сообщение
  Future<void> insertMessage(MessagesCompanion entry) async {
    await into(messages).insertOnConflictUpdate(entry);
  }

  // Получить все сообщения чата (по времени)
  Future<List<Message>> getMessagesByChat(String chatId) async {
    return (select(messages)
          ..where((m) => m.chatId.equals(chatId))
          ..orderBy([(m) => OrderingTerm(expression: m.createdAt, mode: OrderingMode.asc)]))
        .get();
  }

  // Обновить сообщение
  Future<int> updateMessage(String id, {String? content, String? fileUrl}) async {
    return (update(messages)..where((m) => m.id.equals(id))).write(
      MessagesCompanion(
        content: content != null ? Value(content) : const Value.absent(),
        fileUrl: fileUrl != null ? Value(fileUrl) : const Value.absent(),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  // Пометить удаление
  Future<int> markDeleted(String id) async {
    return (update(messages)..where((m) => m.id.equals(id))).write(
      MessagesCompanion(content: const Value('[deleted]')),
    );
  }

  // Последнее сообщение чата
  Future<Message?> getLastMessage(String chatId) async {
    return (select(messages)
          ..where((m) => m.chatId.equals(chatId))
          ..orderBy([(m) => OrderingTerm(expression: m.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }
}
