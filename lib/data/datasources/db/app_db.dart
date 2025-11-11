import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:tik_talk/data/datasources/local/chats_dao.dart';
import 'package:tik_talk/data/datasources/local/messages_dao.dart';
import 'package:tik_talk/data/datasources/local/participants_dao.dart';
import 'package:tik_talk/data/datasources/local/sync_meta_dao.dart';
import 'package:tik_talk/data/datasources/local/users_dao.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'tables.dart';
part 'app_db.g.dart';

LazyDatabase _openConnection(String dbName) {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, dbName));
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [Chats, Messages, Participants, SyncMeta, Users],
  daos: [ChatsDao, MessagesDao, ParticipantsDao, UsersDao, SyncMetaDao],)
class AppDb extends _$AppDb {
  final String? _currentUserId;
  
  final String userId;
  final String dname;

  AppDb({required this.dname, required this.userId}) : 
  _currentUserId = _extractUserIdFromDbName(dname),
  super(_openConnection(dname)); // или укажи путь к файлу
  
  @override
  int get schemaVersion => 1;
  static String? _extractUserIdFromDbName(String dbName) {
    final match = RegExp(r'app_(.+)\.db').firstMatch(dbName);
    return match?.group(1);
  }
  
  Future<String> path(String dbName)async{
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, dbName);
    return path;
  }

  get dbName => dname;

  Future<String> get dbPath async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, dname);
    return path;
  }

  String? get currentUserId => _currentUserId;

  Future<void> deleteFile() async {
    await close(); // важно — закрыть соединение с базой
    final a = await dbPath;
    final file = File(a);
    if (await file.exists()) {
      await file.delete();
    }
  } 

  bool isCurrentUserDb(String userId) {
    return _currentUserId == userId;
  }

  bool get dbIsOpen{
    if (userId != ''){
      return true;
    }
    else{return false;}
  } 
}
