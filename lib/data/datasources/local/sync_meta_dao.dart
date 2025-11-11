import 'package:drift/drift.dart';
import '../db/app_db.dart';

part 'sync_meta_dao.g.dart';

@DriftAccessor(tables: [SyncMeta])
class SyncMetaDao extends DatabaseAccessor<AppDb> with _$SyncMetaDaoMixin {
  SyncMetaDao(AppDb db) : super(db);

  Future<void> updateSyncTime(String key) async {
    await into(syncMeta).insertOnConflictUpdate(
      SyncMetaCompanion(key: Value(key), value: Value(DateTime.now())),
    );
  }

  Future<DateTime?> getSyncTime(String key) async {
    final row = await (select(syncMeta)..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }
  
  Future<SyncMetaData?> getLastInsertedRow() async {
    final query = select(syncMeta)
      ..orderBy([(t) => OrderingTerm.desc(t.value)])
      ..limit(1);
  return await query.getSingleOrNull();
}
}