import 'package:tik_talk/data/DTO/messege_DTO.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';

class MessageServiceRemoteSource {
  final ApiClient apiClient;

  MessageServiceRemoteSource({required this.apiClient});

  Future<String> sendMessage({MessageDTO? message
  }) async {
    try{
      final response = await apiClient.postJson('/message/send', {
        "chatId": message!.chatId,
        "clientId": message.userId,
        'content': message.content,
        'type': message.type.toString(),
        if (message.replyToId != null) 'reply_to_id': message.replyToId,
        if (message.fileUrl != null) 'file_url': message.fileUrl,
        if (message.fileName != null) 'file_name': message.fileName,
        if (message.fileSize != null) 'file_size': message.fileSize,
        if (message.mimeType != null) 'mime_type': message.mimeType,
        if (message.status != null ) 'status' : message.status,
      });

      if (response.containsKey('message_id')) {
        return response['message_id'] as String;
      } else {
        throw Exception(response['error'] ?? 'Ошибка отправки сообщения');
      }
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception('Сессия истекла. Авторизуйтесь заново.');
      } else {
        throw Exception('Ошибка API [${e.statusCode}]: ${e.body}');
      }
    } catch (e) {
      throw Exception('Сетевая ошибка: $e');
    }

  }

  Future<List<dynamic>> getChatMessages({
    required String chatId,
  }) async {
    try{
      final response = await apiClient.getJson('/chat/messages?id=$chatId');

      if (response.containsKey('messages')) {
        return response['messages'] as List<dynamic>;
      } else {
        throw Exception(response['error'] ?? 'Ошибка получения сообщений');
      }
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception('Сессия истекла. Авторизуйтесь заново.');
      } else {
        throw Exception('Ошибка API [${e.statusCode}]: ${e.body}');
      }
    } catch (e) {
      throw Exception('Сетевая ошибка: $e');
    }
  }
}