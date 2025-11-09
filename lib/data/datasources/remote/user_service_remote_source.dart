import 'package:tik_talk/data/api_remote/ApiClient.dart';

class UserServiceRemoteSource {
  final ApiClient apiClient;

  UserServiceRemoteSource({required this.apiClient});

  Future<dynamic> getAllUsers() async {
    final response = await apiClient.getJson('/users?limit=100&offset=0');

    if (response.isEmpty ) {
      throw Exception(response['error'] ?? 'Ошибка получения профиля пользователя');
    } else {
      return response['users'];
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
    final response = await apiClient.putJson('/profile', {
      if (avatarUrl != null) 'avatar': avatarUrl,
      if (aboutMe != null) 'bio': aboutMe,
      if (birthdayDate != null) 'date_of_birth': birthdayDate.toIso8601String(),
    });

    if (response['success'] == true) {
      return true;
    } else {
      throw Exception(response['error'] ?? 'Ошибка обновления профиля');
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