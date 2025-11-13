import 'package:tik_talk/data/api_remote/ApiClient.dart';

class ParticipiantServiceRemoteSource {
  final ApiClient apiClient;

  ParticipiantServiceRemoteSource({required this.apiClient});
  
  Future<bool> addParticipant({
    required String chatId,
    required String userId,
  }) async {
    try{
      final response = await apiClient.postJson('/chat/add', {
        "chat_id": chatId,
        'user_id': userId,
      });

      if (response.containsKey('success') && response['success'] == true) {
        return true;
      } else {
        throw Exception(response['error'] ?? 'Ошибка добавления участника');
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

  Future<List<dynamic>> getChatParticipants(String chatId) async {
    try{
      final response = await apiClient.getJson('/chat/participants/?id=$chatId');

      if (response.containsKey('participants')) {
        return response['participants'] as List<dynamic>;
      } else {
        throw Exception(response['error'] ?? 'Ошибка получения участников чата');
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

  Future<bool> removeParticipant({
    required String chatId,
    required String userId,
  }) async {
    try{
      final response = await apiClient.deleteJson('/chat/remove', {
        "chat_id": chatId,
        "user_id": userId,
      });

      if (response.containsKey('success') && response['success'] == true) {
        return true;
      } else {
        throw Exception(response['error'] ?? 'Ошибка удаления участника');
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

  Future<bool> updateParticipantRole({
    required String chatId,
    required String userId,
    required String role,
  }) async {
    try{
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

  Future<bool> leaveChat(String chatId) async {
    try{
      final response = await apiClient.postJson('/chat/leave', {
        "chat_id": chatId
      });

      if (response.containsKey('success') && response['success'] == true) {
        return true;
      } else {
        throw Exception(response['error'] ?? 'Ошибка выхода из чата');
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