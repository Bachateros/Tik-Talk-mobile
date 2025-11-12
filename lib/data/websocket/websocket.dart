import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:tik_talk/data/datasources/db/app_db.dart';

class WebSocketService {
  final String baseUrl;
  final String token;
  final AppDb db;

  WebSocketChannel? _channel;

  WebSocketService({required this.baseUrl, required this.token, required this.db});

  Future<void> connect() async {
    _channel = IOWebSocketChannel.connect(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Connection': 'Upgrade',
        'Upgrade': 'websocket',
      },
    );

    _channel!.stream.listen((event) async {
      final data = jsonDecode(event);
      await _handleEvent(data);
    }, onDone: _onClose, onError: _onError);
  }

 Future<void> _handleEvent(Map<String, dynamic> data) async {
  final type = data['type']?.toString();
  if (type == null) return;

  switch (type) {
    // case 'message_new':
    //   await db.messagesDao.insertMessage(
    //     MessagesCompanion.insert(
    //       id: data['ID'].toString(),
    //       chatId: data['chatId'].toString(),
    //       userId: data['userId'].toString(),
    //       content: data['content']?.toString(),
    //       type: data['type']?.toString(),
    //       replyToId: data['reply_to_id']?.toString(),
    //       fileUrl: data['file_url']?.toString(),
    //       fileName: data['file_name']?.toString(),
    //       fileSize: data['file_size'] != null
    //           ? Value(int.tryParse(data['file_size'].toString()) ?? 0)
    //           : const Value.absent(),
    //       mimeType: data['mime_type']?.toString(),
    //       status: data['status']?.toString(),
    //       createdAt: DateTime.tryParse(data['CreatedAt'] ?? '') ?? DateTime.now(),
    //     ),
    //   );
    //   break;


    // case 'participant_update':
    //   await db.participantsDao.insertParticipants([
    //     ParticipantsCompanion.insert(
    //       id: data['ID'].toString(),
    //       chatId: data['chatId']?.toString() ?? '',
    //       userId: data['userId']?.toString() ?? '',
    //       role: data['role']?.toString(),
    //       joinedAt: DateTime.tryParse(data['joinedAt'] ?? ''),
    //       isMuted: Value(data['isMuted'] == true || data['isMuted'] == "true"),
    //       notificationsEnabled: Value(
    //         data['notificationsEnabled'] != false &&
    //             data['notificationsEnabled'] != "false",
    //       ),
    //       createdAt: DateTime.tryParse(data['CreatedAt'] ?? ''),
    //       updatedAt: DateTime.tryParse(data['UpdatedAt'] ?? ''),
    //       deletedAt: DateTime.tryParse(data['DeletedAt'] ?? ''),
    //     )
    //   ]);
    //   break;

    // case 'sync_meta_update':
    //   await db.syncMetaDao.insertMeta(
    //     SyncMetaCompanion.insert(
    //       key: ,
    //       value: ,
    //       rowid: ,
    //       // tableName: data['table']?.toString() ?? '',
    //       // lastSyncAt: DateTime.tryParse(data['lastSyncAt'] ?? ''),
    //     ),
    //   );
    //   break;

    default:
      print('[WS] Unknown event type: $type');
  }
}


  void _onClose() {
    print('WebSocket closed');
  }

  void _onError(err) {
    print('WebSocket error: $err');
  }

  void dispose() {
    _channel?.sink.close();
  }
}



/* void _handleEvent(dynamic event) async {
  final data = jsonDecode(event);

  switch (data['type']) {
    case 'message':
      final message = Message.fromJson(data['payload']);
      await messagesDao.upsertMessage(message);
      break;

    // другие типы: chat, participant и т.д.
  }

  // После обновления уведомляем слушателей (если используешь Stream или Bloc)
  _onDataUpdated.add(true);
} */

/* case 'participant_update':
      final userId = data['userId']?.toString();
      if (userId == null || userId != db.currentUserId) return;

      final chatId = data['chatId']?.toString();
      if (chatId == null) return;

      final existingChatIds = await db.chatsDao.getAllChatIds();

      if (!existingChatIds.contains(chatId)) {
        // Получаем детали чата с сервера
        final chatData = await SyncService().getChatDetails(chatId);
        final participants = await SyncService().getChatParticipants(chatId);

        // Сохраняем чат
        await db.chatsDao.insertChats([
          ChatsCompanion.insert(
            id: chatData['id'].toString(),
            name: chatData['name'] ?? '',
            description: Value(chatData['description']),
            createdAt: DateTime.tryParse(chatData['createdAt'] ?? '') ?? DateTime.now(),
            updatedAt: DateTime.tryParse(chatData['updatedAt'] ?? '') ?? DateTime.now(),
          )
        ]);

        // Сохраняем участников
        final participantsList = participants.map((p) {
          return ParticipantsCompanion.insert(
            id: p['id'].toString(),
            chatId: chatId,
            userId: p['userId'].toString(),
            role: Value(p['role']),
            joinedAt: DateTime.tryParse(p['joinedAt'] ?? ''),
          );
        }).toList();

        await db.participantsDao.insertParticipants(participantsList);
      } else {
        // Просто обновляем участника
        await db.participantsDao.insertParticipants([
          ParticipantsCompanion.insert(
            id: data['ID'].toString(),
            chatId: chatId,
            userId: userId,
            role: Value(data['role']),
            updatedAt: DateTime.tryParse(data['UpdatedAt'] ?? ''),
          ),
        ]);
      }
      break; */