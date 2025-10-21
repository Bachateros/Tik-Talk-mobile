import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tik_talk/models/user.dart';

  final String baseUrl = 'http://localhost:8080';

  // Простой POST /login, ожидаем JSON { "token": "..." }
  Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      // Предполагаем что в ответе поле token
      return body['token'] as String?;
    } else {
      // Здесь можно логировать response.body для дебага
      return null;
    }
  }

  // Пример запроса /me (получить профиль текущего пользователя)
  // Для авторизованных запросов мы должны передать заголовок Authorization: Bearer <token>
  Future<User?> fetchProfile(String token) async {
    final url = Uri.parse('$baseUrl/me');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return User.fromJson(body);
    }
    return null;
  }