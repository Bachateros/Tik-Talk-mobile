import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';

class MessageServiceRemoteSource {
  final ApiClient apiClient;

  MessageServiceRemoteSource({required this.apiClient});

  Future<String> sendMessage({
    required String chatId,
    required String content,
    required MessageType type,
    required String userId,
    String? replyToId,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? mimeType,
    String? status,
  }) async {
    final response = await apiClient.postJson('/message/send', {
      "chatId": chatId,
      "clientId": userId,
      'content': content,
      'type': type.toString(),
      if (replyToId != null) 'reply_to_id': replyToId,
      if (fileUrl != null) 'file_url': fileUrl,
      if (fileName != null) 'file_name': fileName,
      if (fileSize != null) 'file_size': fileSize,
      if (mimeType != null) 'mime_type': mimeType,
      if (status != null ) 'status' : status,
    });

    if (response.containsKey('message_id')) {
      return response['message_id'] as String;
    } else {
      throw Exception(response['error'] ?? 'Ошибка отправки сообщения');
    }
  }

  Future<List<dynamic>> getChatMessages({
    required String chatId,
  }) async {
    final response = await apiClient.getJson('/chat/messages?id=$chatId');

    if (response.containsKey('messages')) {
      return response['messages'] as List<dynamic>;
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения сообщений');
    }
  }
}