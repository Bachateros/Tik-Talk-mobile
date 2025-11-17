import 'package:drift/drift.dart';
import 'package:tik_talk/data/DTO/participant_DTO.dart';
import '../db/app_db.dart';

part 'participants_dao.g.dart';

@DriftAccessor(tables: [Participants])
class ParticipantsDao extends DatabaseAccessor<AppDb> with _$ParticipantsDaoMixin {
  ParticipantsDao(AppDb db) : super(db);

  Future<void> insertOrUpdate(ParticipantDto participantDTO) async {
    final now = DateTime.now();
    await into(participants).insertOnConflictUpdate(
      ParticipantsCompanion(
        id: Value(participantDTO.id!),
        chatId: Value(participantDTO.chatId),
        userId: Value(participantDTO.userId),
        role: Value(participantDTO.role),
        isMuted: Value(participantDTO.isMuted!),
        notificationsEnabled: Value(participantDTO.notificationsEnabled ?? true),
        isDeleted: Value(participantDTO.isDeleted!),
        joinedAt: Value(participantDTO.joinedAt ?? DateTime(0)),
        updatedAt: Value(participantDTO.updatedAt ?? now),
      ),
    );
  }

  //Вернуть список данных участника личных сообщений
  Future<String?> getDirectContact(String chatId, String currentUserId) async {
    final participantsList = await (select(participants)
          ..where((p) => p.chatId.equals(chatId))
          ..where((p) => p.userId.isNotValue(currentUserId)))
        .get();

    if (participantsList.isNotEmpty) {
      return participantsList.first.userId;
    }

    return null; // если вдруг нет второго участника
  }


  // Вернуть список chatId, где участвует данный пользователь
  Future<List<String>> getChatIdsByUser(String userId) async {
    final q = select(participants)..where((p) => p.userId.equals(userId));
    final rows = await q.get();
    return rows.map((r) => r.chatId).toList();
  }

  // Вернуть всех участников для набора чатов
  Future<List<Participant>> getParticipantsByChatIds(List<String> chatIds) async {
    return (select(participants)..where((p) => p.chatId.isIn(chatIds))).get();
  }


  // Добавить участников
  Future<void> insertParticipants(List<ParticipantsCompanion> entries) async {
    await batch((b) => b.insertAllOnConflictUpdate(participants, entries));
  }

  // Достать участников по chatId
  Future<List<Participant>> getParticipantsByChat(String chatId) async {
    return (select(participants)
          ..where((p) => p.chatId.equals(chatId))
          ..where((p) => p.deletedAt.isNull())
          ..where((p) => p.isDeleted.equals(false)))
          .get();
  }

  // Достать всех уникальных участников (DISTINCT userId)
  Future<List<String>> getDistinctUserIds() async {
    final q = customSelect('SELECT DISTINCT user_id FROM participants', readsFrom: {participants});
    final rows = await q.get();
    return rows.map((r) => r.data['user_id'] as String).toList();
  }

  // Обновить информацию участника
  Future<int> updateParticipant(String id, {String? role}) async {
    return (update(participants)..where((p) => p.id.equals(id))).write(
      ParticipantsCompanion(
        role: role != null ? Value(role) : const Value.absent(),
        joinedAt: Value(DateTime.now()), 
      ),
    );
  }

  // Пометить участника как удалённого
  Future<int> markParticipantRemoved(String id) async {
    return (update(participants)..where((p) => p.id.equals(id))).write(
      ParticipantsCompanion(
        isDeleted: Value(true),
        deletedAt: Value(DateTime.now())
        ),
    );
  }

  Future<int> deleteByChatAndUser(String userid, String chatId) async {
    return (update(participants)
                ..where((p) => (p.userId.equals(userid)))
                ..where((p)=> (p.chatId.equals(chatId))))
                .write(
      ParticipantsCompanion(
        isDeleted: Value(true),
        deletedAt: Value(DateTime.now(),)
        ),
    );
  }
}
