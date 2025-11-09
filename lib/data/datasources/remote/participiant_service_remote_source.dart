import 'package:tik_talk/data/api_remote/ApiClient.dart';

class ParticipiantServiceRemoteSource {
  final ApiClient apiClient;

  ParticipiantServiceRemoteSource({required this.apiClient});

  Future<bool> addParticipant({
    required String chatId,
    required String userId,
  }) async {
    final response = await apiClient.postJson('/chat/add', {
      "chat_id": chatId,
      'user_id': userId,
    });

    if (response.containsKey('success') && response['success'] == true) {
      return true;
    } else {
      throw Exception(response['error'] ?? 'Ошибка добавления участника');
    }
  }

  Future<List<dynamic>> getChatParticipants(String chatId) async {
    final response = await apiClient.getJson('/chat/participants/?id=$chatId');

    if (response.containsKey('participants')) {
      return response['participants'] as List<dynamic>;
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения участников чата');
    }
  }

  Future<bool> removeParticipant({
    required String chatId,
    required String userId,
  }) async {
    final response = await apiClient.deleteJson('/chat/remove', {
      "chat_id": chatId,
      "user_id": userId,
    });

    if (response.containsKey('success') && response['success'] == true) {
      return true;
    } else {
      throw Exception(response['error'] ?? 'Ошибка удаления участника');
    }
  }

  Future<bool> updateParticipantRole({
    required String chatId,
    required String userId,
    required String role,
  }) async {
    final response = await apiClient.putJson('/chat/participant', {
      "chat_id": chatId,
      "user_id": userId,
      'role': role,
    });

    if (response.containsKey('success') && response['success'] == true) {
      return true;
    } else {
      throw Exception(response['error'] ?? 'Ошибка обновления роли участника');
    }
  }

  Future<bool> leaveChat(String chatId) async {
    final response = await apiClient.postJson('/chat/leave', {
      "chat_id": chatId
    });

    if (response.containsKey('success') && response['success'] == true) {
      return true;
    } else {
      throw Exception(response['error'] ?? 'Ошибка выхода из чата');
    }
  }
}