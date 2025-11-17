import 'package:tik_talk/data/DTO/chat_DTO.dart';
import 'package:tik_talk/data/DTO/participant_DTO.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/data/mapers/chat_mapper.dart';
import 'package:tik_talk/data/mapers/participant_mapper.dart';

class ChatsServiceRemoteSource {
  ChatMapper chatMapper;
  ParticipantMapper participantMapper;
  final ApiClient apiClient;

  ChatsServiceRemoteSource({required this.apiClient, required this.chatMapper, required this.participantMapper});

  Future<String?> createChat(ChatDTO chatDto, List<ParticipantDto?> participants) async {
    try {
      // 1. Конвертируем участников в JSON для запроса
      final participantsJson = participants
          .where((e) => e != null)
          .map((p) => participantMapper.toResponse(p!))
          .toList();

      // 2. Формируем JSON для чата через мапер
      final chatBody = chatMapper.toResponse(chatDto);

      final response = await apiClient.postJson('/chat/create', {
        ...chatBody,
        'participants': participantsJson,
      });

      if (response.containsKey('chat')) {
        final chatDto = chatMapper.fromResponse(response['chat']);
        if (chatDto.id != null || chatDto.id != ''){
          return chatDto.id;
        }else{
          return null;
        }
      } else {
        throw Exception(response['error'] ?? 'Ошибка создания чата');
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


  Future<bool> deleteChat(String chatId) async {
    try {
      final response = await apiClient.deleteJson('/chat', {"chat_id": chatId});
      if (response.containsKey('result')) {
        final resultValue = response['result'];
      if (resultValue == 'chat deleted') {
        return true;
      } 
      else {
        return false;
      }
    } else {
      throw Exception(response['error'] ?? 'Ошибка удаления чата');
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

  Future<ChatDTO> updateChat(ChatDTO chatDTO) async {
      try {
        final response = await apiClient.putJson('/chat/', {
          'chat_id': chatDTO.id,
          if (chatDTO.name != '') 'name': chatDTO.name,
          if (chatDTO.description != null) 'description': chatDTO.description,
          if (chatDTO.avatarUrl != null) 'avatarUrl': chatDTO.avatarUrl,
          if (chatDTO.isPrivate != '') 'is_private': chatDTO.isPrivate,
        });
        if (response.containsKey('chat_id')) {
          return chatMapper.fromResponse(response);
        } else {
          throw Exception(response['error'] ?? 'Ошибка удаления чата');
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
      
      if (response.containsKey('chats')) {
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

  Future<List<dynamic>> getAllChats() async {
    try{
      final response = await apiClient.getJson('/chats/all');

      if (response.containsKey('chats')) {
        return response['chats'] as List<dynamic>;
      } else {
        throw Exception(response['error'] ?? 'Ошибка получения списка чатов');
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

  Future<Map<String, dynamic>> getChatDetails(String chatId) async {
    try{
      final response = await apiClient.getJson('/chat/$chatId');
      if (response.containsKey('chat')) {
        return response['chat'] as Map<String, dynamic>;
      } else {
        throw Exception(response['error'] ?? 'Ошибка получения информации о чате');
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