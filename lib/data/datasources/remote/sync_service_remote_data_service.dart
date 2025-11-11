import 'package:tik_talk/data/DTO/chat_DTO.dart';
import 'package:tik_talk/data/DTO/messege_DTO.dart';
import 'package:tik_talk/data/DTO/participant_DTO.dart';
import 'package:tik_talk/data/DTO/user_DTO.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/data/mapers/chat_mapper.dart';
import 'package:tik_talk/data/mapers/message_mapper.dart';
import 'package:tik_talk/data/mapers/participant_mapper.dart';
import 'package:tik_talk/data/mapers/user_mapper.dart';

class SyncServiceRemoteDataService {
  final ApiClient apiClient;
  final ChatMapper _chatMapper = ChatMapper();
  final UserMapper _userMapper = UserMapper();
  final MessageMapper _messageMapper = MessageMapper();
  final ParticipantMapper _participantMapper = ParticipantMapper();

  SyncServiceRemoteDataService({required this.apiClient});

  Future<List<ChatDTO>> fetchChats() async {
    final response = await apiClient.getJson('/chats');

    if (response.containsKey('chats')) {
      final list = response['chats'] as List<dynamic>;
      return list
          .map((json) => _chatMapper.fromResponse(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения чатов');
    }
  }

  Future<List<UserDTO>> fetchUsers() async {
    final response = await apiClient.getJson('/users/full?limit=100&offset=0');

    if (response.containsKey('users')) {
      final list = response['users'] as List<dynamic>;
      return list
          .map((json) => _userMapper.fromResponse(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения пользователей');
    }
  }

  Future<List<ParticipantDto>> fetchParticipants({
    required String chatId,
    required String since,
  }) async {
    final response = await apiClient
        .getJson('/chat/participants/?id=$chatId&since=$since');

    if (response.containsKey('participants')) {
      final list = response['participants'] as List<dynamic>;
      return list
          .map((json) =>
              _participantMapper.fromResponse(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения участников чата');
    }
  }

  Future<List<MessageDTO>> fetchMessages({
    required String chatId,
    required String since,
  }) async {
    final response =
        await apiClient.getJson('/chat/messages?id=$chatId&since=$since');

    if (response.containsKey('messages')) {
      final list = response['messages'] as List<dynamic>;
      return list
          .map((json) =>
              _messageMapper.fromResponse(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения сообщений');
    }
  }
}
