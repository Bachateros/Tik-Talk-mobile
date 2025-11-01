import 'package:tik_talk/data/api_remote/ApiClient.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService(this.apiClient);

  Future<Map<String, dynamic>> register({
    required String name,
    required String surname,
    required String tgUsername,
    required String password,
  }) async {
    return apiClient.postJson('/register', {
      'name': name,
      'surname': surname,
      'tg_username': tgUsername,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> login({
    required String tgUsername,
    required String password,
  }) async {
    return apiClient.postJson('/login', {
      'tg_username': tgUsername,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> verify({
    required int userId,
    required String code,
  }) async {
    return apiClient.postJson('/login/verify', {
      'user_id': userId,
      'code': code,
    });
  }

  Future<Map<String, dynamic>> refresh({
    required String refreshToken,
  }) async {
    return apiClient.postJson('/refresh', {
      'refresh_token': refreshToken,
    });
  }

  Future<Map<String, dynamic>> logout({
    required String accessToken,
  }) async {
    // Some APIs expect token in header; here we send body as example.
    return apiClient.postJson('/logout', {
      'access_token': accessToken,
    });

  }
}