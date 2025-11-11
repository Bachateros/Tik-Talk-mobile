import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';

class ChatsServiceRemoteSource {
  final ApiClient apiClient;

  ChatsServiceRemoteSource({required this.apiClient});

  Future<String> createChat({
    required String name,
    required String? description,
    required ChatType type,
    required String? avatarUrl,
    required bool isPrivate,
    required List<Map<String, String>> participants,
  }) async {
    final response = await apiClient.postJson('/chat/create', {
      'name': name,
      'description': description,
      'type': type.toString(),
      'avatarUrl': avatarUrl,
      'is_private': isPrivate,
      'participants': participants,
    });

    if (response.containsKey('chat_id')) {
      return response['chat_id'] as String;
    } else {
      throw Exception(response['error'] ?? 'Ошибка создания чата');
    }
  }

  Future<bool> deleteChat(String chatId) async {
    final response = await apiClient.deleteJson('/chat/', {"chat_id": chatId});

    if (response.containsKey('success') && response['success'] == true) {
      return true;
    } else {
      throw Exception(response['error'] ?? 'Ошибка удаления чата');
    }
  }

  Future<String> updateChat({
    required String chatId,
    required String? name,
    required String? description,
    required String? avatarUrl,
    required bool? isPrivate,
  }) async {
    final response = await apiClient.putJson('/chat/', {
      'chat_id': chatId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (isPrivate != null) 'is_private': isPrivate,
    });

    if (response.containsKey('chat_id')) {
      return response['chat_id'] as String;
    } else {
      throw Exception(response['error'] ?? 'Ошибка обновления чата');
    }
  }

  Future<List<dynamic>> getUserChats() async {
    final response = await apiClient.getJson('/chats');
    
    if (response.containsKey('chats')) {
      return response['chats'] as List<dynamic>;
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения чатов');
    }
  }

  Future<List<dynamic>> getAllChats() async {
    final response = await apiClient.getJson('/chats/all');

    if (response.containsKey('chats')) {
      return response['chats'] as List<dynamic>;
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения списка чатов');
    }
  }

  Future<Map<String, dynamic>> getChatDetails(String chatId) async {
    final response = await apiClient.getJson('/chat/$chatId');

    if (response.containsKey('chat')) {
      return response['chat'] as Map<String, dynamic>;
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения информации о чате');
    }
  }
}