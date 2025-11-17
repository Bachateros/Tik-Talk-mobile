import 'package:tik_talk/data/DTO/participant_DTO.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';
import 'package:tik_talk/data/mapers/participant_mapper.dart';

class ParticipiantServiceRemoteSource {
  final ApiClient apiClient;
  final ParticipantMapper mapper;

  ParticipiantServiceRemoteSource({
    required this.apiClient,
    required this.mapper,
  });

  /// Добавить участника — возвращает DTO добавленного участника
  Future<ParticipantDto> addParticipant({
    required String chatId,
    required String userId,
  }) async {
    try {
      final response = await apiClient.postJson('/chat/add', {
        "chat_id": chatId,
        "user_id": userId,
      });

      if (response.containsKey('participant')) {
        return mapper.fromResponse(response['participant']);
      } else {
        throw Exception("Ошибка: не получен participant");
      }
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception("Сессия истекла. Авторизуйтесь заново.");
      }
      throw Exception("Ошибка API [${e.statusCode}]: ${e.body}");
    }
  }

  /// Получить список участников чата в DTO
  Future<List<ParticipantDto>> getChatParticipants(String chatId) async {
    try {
      final response =
          await apiClient.getJson('/chat/participants/?id=$chatId');

      if (!response.containsKey('participants')) {
        throw Exception("Некорректный ответ сервера");
      }

      final list = response['participants'] as List<dynamic>;

      return list
          .map<ParticipantDto>((p) => mapper.fromResponse(p))
          .toList();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception("Сессия истекла. Авторизуйтесь заново.");
      }
      throw Exception("Ошибка API [${e.statusCode}]: ${e.body}");
    }
  }

  /// Удаление участника — возвращает DTO удалённого или обновлённого участника
  Future<bool> removeParticipant({
    required String chatId,
    required String userId,
  }) async {
    try {
      final response = await apiClient.deleteJson('/chat/remove', {
        "chat_id": chatId,
        "user_id": userId,
      });

      if (response.containsKey('participant')) {
        return true;
      }

      return false; // сервер мог вернуть только success=true
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception("Сессия истекла. Авторизуйтесь заново.");
      }
      throw Exception("Ошибка API [${e.statusCode}]: ${e.body}");
    }
  }

  /// Обновить роль — возвращает DTO участника с новой ролью
  Future<ParticipantDto> updateParticipantRole({
    required String chatId,
    required String userId,
    required String role,
  }) async {
    try {
      final response = await apiClient.putJson('/chat/participant', {
        "chat_id": chatId,
        "user_id": userId,
        "role": role,
      });

      if (response.containsKey('participant')) {
        return mapper.fromResponse(response['participant']);
      } else {
        throw Exception("Ответ сервера не содержит participant");
      }
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception("Сессия истекла. Авторизуйтесь заново.");
      }
      throw Exception("Ошибка API [${e.statusCode}]: ${e.body}");
    }
  }

  /// Выйти из чата — возвращает DTO участника, который покинул чат
  Future<ParticipantDto?> leaveChat(String chatId) async {
    try {
      final response = await apiClient.postJson('/chat/leave', {
        "chat_id": chatId
      });

      if (response.containsKey('participant')) {
        return mapper.fromResponse(response['participant']);
      }

      return null;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        throw Exception("Сессия истекла. Авторизуйтесь заново.");
      }
      throw Exception("Ошибка API [${e.statusCode}]: ${e.body}");
    }
  }
}
