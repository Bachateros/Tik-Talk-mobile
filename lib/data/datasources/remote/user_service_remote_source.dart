import 'package:intl/intl.dart';
import 'package:tik_talk/data/api_remote/ApiClient.dart';

class UserServiceRemoteSource {
  final ApiClient apiClient;

  UserServiceRemoteSource({required this.apiClient});

  Future<T> safeApiCall<T>(Future<T> Function() call) async {
    try {
      return await call();
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

  Future<dynamic> getAllUsers() async {
    try{
      final response = await apiClient.getJson('/users?limit=100&offset=0');

      if (response.isEmpty ) {
        throw Exception(response['error'] ?? 'Ошибка получения профиля пользователя');
      } else {
        return response['users'];
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

  Future<dynamic> getUserProfile(String? userId) async {
    final response = await apiClient.getJson('/profile?user_id=$userId');

    if (response.isEmpty) {
      throw Exception(response['error'] ?? 'Ошибка получения профиля пользователя');
    } else {
      return response['profile'];
    }
  }

  Future<dynamic> getCurrentUserProfile() async {
    final response = await apiClient.getJson('/users/me');

    if (response['success'] == true) {
      return response['user'];
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения текущего профиля');
    }
  }

  Future<bool> updateUserProfile({
    String? avatarUrl,
    String? aboutMe,
    DateTime? birthdayDate,
  }) async {
    try{
      final response = await apiClient.putJson('/profile', {
        if (avatarUrl != null) 'avatar': avatarUrl,
        if (aboutMe != null && aboutMe != '') 'bio': aboutMe,
        if (birthdayDate != null) 'date_of_birth':  DateFormat('yyyy-MM-dd').format(birthdayDate),
      });
      // '${birthdayDate.year}-${birthdayDate.month}-${birthdayDate.day}'
      final resultValue = response['result'] ?? response['success'] ?? response['ok'];
      if (resultValue == 'ok' || resultValue == true) {
        return true;
      } 
      else {
        return false;
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

  Future<List<dynamic>> getUserContacts() async {
    final response = await apiClient.getJson('/users/contacts');

    if (response['success'] == true) {
      return response['contacts'] as List<dynamic>;
    } else {
      throw Exception(response['error'] ?? 'Ошибка получения контактов');
    }
  }
}