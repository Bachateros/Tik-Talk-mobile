import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'tables.dart';
part 'app_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'tik_talk_db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Chats, Messages, Participants, SyncMeta])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection()); // или укажи путь к файлу

  @override
  int get schemaVersion => 1;

  // // пример вставки
  // Future<void> upsertChat(Participants c) async {
  //   await into(chats).insertOnConflictUpdate(c);
  // }

  // // пример наблюдения
  // Stream<List<ChatEntitie>> watchChats() => select(chats).watch();
}
