import 'package:tik_talk/data/api_remote/ApiClient.dart';

class SearchServiceRemoteSource {
  final ApiClient apiClient;

  SearchServiceRemoteSource({required this.apiClient});

  Future<List<dynamic>> searchChats(String query) async {
    try{
      final response = await apiClient.getJson('/chats/search?query=${Uri.encodeComponent(query)}');

      if (response['success'] == true) {
        return response['chats'] as List<dynamic>;
      } else {
        throw Exception(response['error'] ?? 'Ошибка поиска чатов');
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

  Future<List<dynamic>> getUserChats() async {
    try{
      final response = await apiClient.getJson('/chats');

      if (response['success'] == true) {
        return response['chats'] as List<dynamic>;
      } else {
        throw Exception(response['error'] ?? 'Ошибка получения чатов');
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

  Future<List<dynamic>> searchUsers(String query) async {
    try{
      final response = await apiClient.getJson('/users/search?query=${Uri.encodeComponent(query)}');

      if (response['success'] == true) {
        return response['users'] as List<dynamic>;
      } else {
        throw Exception(response['error'] ?? 'Ошибка поиска пользователей');
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