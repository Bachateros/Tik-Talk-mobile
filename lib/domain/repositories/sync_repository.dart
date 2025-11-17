abstract class SyncRepository {
  Future<void>syncAll();
  Future<void>printAllTables();
  Future<void>syncChat(String chatId);
  Future<void>markChatDeleted(String chatId);
  Future<void>markParticipantDeleted(String chatId, String userId); 
  Future<void> syncMessages(String chatId);
}
