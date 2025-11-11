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
        id: Value(participantDTO.id),
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

  // Добавить участников
  Future<void> insertParticipants(List<ParticipantsCompanion> entries) async {
    await batch((b) => b.insertAllOnConflictUpdate(participants, entries));
  }

  // Достать участников по chatId
  Future<List<Participant>> getParticipantsByChat(String chatId) async {
    return (select(participants)..where((p) => p.chatId.equals(chatId))).get();
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
        joinedAt: Value(DateTime.now()), // можно хранить updatedAt, если добавишь
      ),
    );
  }

  // Пометить участника как удалённого (например статус "removed")
  Future<int> markParticipantRemoved(String id) async {
    return (update(participants)..where((p) => p.id.equals(id))).write(
      ParticipantsCompanion(role: Value('removed')),
    );
  }
}
