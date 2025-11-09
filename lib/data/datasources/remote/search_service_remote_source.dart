import 'package:tik_talk/data/api_remote/ApiClient.dart';

class SearchServiceRemoteSource {
  final ApiClient apiClient;

  SearchServiceRemoteSource({required this.apiClient});

  Future<List<dynamic>> searchChats(String query) async {
    final response = await apiClient.getJson('/chats/search?query=${Uri.encodeComponent(query)}');

    if (response['success'] == true) {
      return response['chats'] as List<dynamic>;
    } else {
      throw Exception(response['error'] ?? 'Ошибка поиска чатов');
    }
  }

  Future<List<dynamic>> getUserChats() async {
    final response = await apiClient.getJson('/chats');

    if (response['success'] == true) {
      return response['chats'] as List<dynamic>;
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения чатов');
    }
  }

  Future<List<dynamic>> searchUsers(String query) async {
    final response = await apiClient.getJson('/users/search?query=${Uri.encodeComponent(query)}');

    if (response['success'] == true) {
      return response['users'] as List<dynamic>;
    } else {
      throw Exception(response['error'] ?? 'Ошибка поиска пользователей');
    }
  }
}