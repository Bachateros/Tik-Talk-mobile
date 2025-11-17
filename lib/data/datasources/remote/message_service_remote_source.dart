import 'dart:async';

import 'package:tik_talk/data/DTO/messege_DTO.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/data/mapers/message_mapper.dart';

class MessageServiceRemoteSource {
  final ApiClient apiClient;
  final MessageMapper messageMapper;

  MessageServiceRemoteSource({required this.apiClient, required this.messageMapper});

  void sendMessage(MessageDTO message) {
    // отправляем, но намеренно не ждём результат
    unawaited(_sendMessageInternal(message));
  }

  Future<void> _sendMessageInternal(MessageDTO message) async {
      await apiClient.postJson('/message/send', messageMapper.toResponse(message));
    
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