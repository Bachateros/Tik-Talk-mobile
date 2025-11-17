import 'package:tik_talk/data/datasources/db/app_db.dart';
import 'package:tik_talk/data/datasources/remote/sync_service_remote_data_service.dart';
import 'package:tik_talk/domain/repositories/sync_repository.dart';

class SyncRepositoryIMPL extends SyncRepository {
  final AppDb db;
  final SyncServiceRemoteDataService syncService;

  SyncRepositoryIMPL({
    required this.db,
    required this.syncService,
  });

  // =============================
  // FULL SYNC (HOME STARTUP)
  // =============================
  @override
  Future<void> syncAll() async {
    print('[SYNC] Starting full sync...');

    final serverChats = await syncService.fetchChats();
    final serverUsers  = await syncService.fetchUsers();

    // final localChats = await db.chatsDao.getAllChatIds();

    await db.transaction(() async {
      // INSERT / UPDATE CHATS
      for (final chat in serverChats) {
        await db.chatsDao.insertOrUpdate(chat);
      }

      // INSERT / UPDATE USERS
      for (final user in serverUsers) {
        await db.usersDao.insertOrUpdate(user);
      }
    });

    // === SYNC MESSAGES + PARTICIPANTS FOR EACH CHAT ===
    for (final chat in serverChats) {
      await syncChat(chat.id!);
      await syncMessages(chat.id!);
    }

    print('[SYNC] Full sync complete');
    await printAllTables();
  }

  // =============================
  // SYNC SPECIFIC CHAT
  // =============================
  @override
  Future<void> syncChat(String chatId) async {
    print('[SYNC] syncChat($chatId)');

    // Сервер не имеет "fetchChat(chatId)" → грузим всё и берём 1 чат
    final allChats = await syncService.fetchChats();
    final chat = allChats.firstWhere(
      (c) => c.id.toString() == chatId.toString(),
      orElse: () => throw Exception('Chat $chatId not found on server'),
    );

    await db.chatsDao.insertOrUpdate(chat);

    final participants = await syncService.fetchParticipants(
      chatId: chatId,
      since: '0',
    );

    await db.transaction(() async {
      for (final p in participants) {
        await db.participantsDao.insertOrUpdate(p);
      }
    });
  }

  // =============================
  // SYNC ONLY MESSAGES OF CHAT
  // =============================
  @override
  Future<void> syncMessages(String chatId) async {
    print('[SYNC] syncMessages($chatId)');

    final key = 'SyncMessages_$chatId';


    final messages = await syncService.fetchMessages(
      chatId: chatId,
      since: '0',
    );

    await db.transaction(() async {
      for (final msg in messages) {
        await db.messagesDao.insertOrUpdate(msg);
      }
      await db.syncMetaDao.updateSyncTime(key);
    });
  }

  // =============================
  // MARK CHAT/PARTICIPANT DELETED
  // =============================
  @override
  Future<void> markChatDeleted(String chatId) async {
    await db.chatsDao.markChatDeleted(chatId);
  }

  @override
  Future<void> markParticipantDeleted(String chatId, String userId) async {
    await db.participantsDao.deleteByChatAndUser(userId, chatId);
  }

  // =============================
  // DEBUG OUTPUT
  // =============================
  @override
  Future<void> printAllTables() async {
    print('======== CHATS ========');
    for (final c in await db.select(db.chats).get()) {
      print(c);
    }

    print('======== PARTICIPANTS ========');
    for (final p in await db.select(db.participants).get()) {
      print(p);
    }

    print('======== MESSAGES ========');
    for (final m in await db.select(db.messages).get()) {
      print(m);
    }

    print('======== USERS ========');
    for (final u in await db.select(db.users).get()) {
      print(u);
    }

    print('======== META ========');
    for (final s in await db.select(db.syncMeta).get()) {
      print('${s.key} : ${s.value}');
    }
  }
  

}
