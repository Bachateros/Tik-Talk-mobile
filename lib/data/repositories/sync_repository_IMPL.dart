import 'package:tik_talk/data/datasources/db/app_db.dart';
import 'package:tik_talk/data/datasources/remote/sync_service_remote_data_service.dart';
import 'package:tik_talk/domain/repositories/sync_repository.dart';

class SyncRepositoryIMPL extends SyncRepository{
  final AppDb db;
  final SyncServiceRemoteDataService syncService;

  SyncRepositoryIMPL({
    required this.db,
    required this.syncService,
  });
  
  Future<void> syncAll() async {
    final  lastSync = await db.syncMetaDao.getSyncTime('SyncAll');
    final since =  lastSync == null ? 0 : lastSync.millisecondsSinceEpoch ~/ 1000; // секунды
    // final now = DateTime.now();

    // 🔹 1. Загружаем с сервера
    final chats = await syncService.fetchChats();
    final users = await syncService.fetchUsers();

    // 🔹 2. Сохраняем чаты и пользователей
    try {
      await db.transaction(() async {
        for (final chat in chats) {
          await db.chatsDao.insertOrUpdate(chat);
        }
        for (final user in users) {
          await db.usersDao.insertOrUpdate(user);
        }
      });
    } catch (e){
      throw Exception('Error insert Chats and Users');
    }

    // 🔹 3. Берём ID всех чатов
    final chatIds = await db.chatsDao.getAllChatIds();
    // 🔹 4. Для каждого чата тянем сообщения и участников
    await db.transaction(() async {
      for (final chatId in chatIds) {
        if (chatId !=null ){
          final messages =
            await syncService.fetchMessages(chatId: chatId, since: since.toString());
          for (final message in messages) {
            try{
              await db.messagesDao.insertOrUpdate(message);
            } catch (e){
                throw Exception('Error insert Message ');
              }
          }
        
          final participants = await syncService.fetchParticipants(
            chatId: chatId,
            since: since.toString(),
          );
          for (final part in participants) {
            try{
              await db.participantsDao.insertOrUpdate(part);
            } catch (e){
              throw Exception('Error insert Participants');
            }
          }
        }
      }

      await db.syncMetaDao.updateSyncTime('SyncAll');
    });
  }
  Future<void> printAllTables() async {
    final chats = await db.select(db.chats).get();
    print('--- CHATS (${chats.length}) ---');
    for (final c in chats) {
      print(c);
    }

    final messages = await db.select(db.messages).get();
    print('--- MESSAGES (${messages.length}) ---');
    for (final m in messages) {
      print(m);
    }

    final participants = await db.select(db.participants).get();
    print('--- PARTICIPANTS (${participants.length}) ---');
    for (final p in participants) {
      print(p);
    }

    final users = await db.select(db.users).get();
    print('--- USERS (${users.length}) ---');
    for (final u in users) {
      print(u);
    }

    final meta = await db.select(db.syncMeta).get();
    print('--- SYNC_META (${meta.length}) ---');
    for (final s in meta) {
      print('${s.key} = ${s.value}');
    }
  }


  // // Получаем дату последней синхронизации
  // Future<DateTime?> _getLastSyncDate() async {
  //   final meta = await (db.select(db.syncMeta)
  //         ..where((tbl) => tbl.key.equals('last_sync')))
  //       .getSingleOrNull();
  //   return meta?.value;
  // }

  // // Обновляем дату последней синхронизации
  // Future<void> _updateLastSyncDate(DateTime date) async {
  //   await db.into(db.syncMeta).insertOnConflictUpdate(
  //     SyncMetaCompanion.insert(
  //       key: 'last_sync',
  //       value: Value(date),
  //     ),
  //   );
  // }
}
