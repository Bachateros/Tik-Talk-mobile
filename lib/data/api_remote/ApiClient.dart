import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';

class ApiClient {
  final String baseUrl;
  final AuthLocalDataSource localDataSource;
  final http.Client httpClient;

  ApiClient({
    required this.baseUrl,
    required this.localDataSource,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Future<http.Response> _sendRaw(
    String endpoint, {
    required String method,
    Map<String, String>? headers,
    Object? body,
    bool retrying = false,
  }) async {
    final accessToken = await localDataSource.getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');

    // 🧠 Стандартные заголовки, имитирующие Postman
    final fullHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      'User-Agent': 'TikTalk/1.0 (Flutter)',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
      ...?headers,
    };

    late http.Response response;
    switch (method.toUpperCase()) {
      case 'POST':
        response = await httpClient.post(uri, headers: fullHeaders, body: body);
        break;
      case 'PUT':
        response = await httpClient.put(uri, headers: fullHeaders, body: body);
        break;
      case 'DELETE':
        response = await httpClient.delete(uri, headers: fullHeaders, body: body);
        break;
      default:
        response = await httpClient.get(uri, headers: fullHeaders);
    }

    // ⚙️ Попытка обновления токена при 401
    if (response.statusCode == 401 && !retrying) {
      final refreshToken = await localDataSource.getRefreshToken();
      if (refreshToken != null) {
        final newTokens = await _refreshWithHttp(refreshToken);
        if (newTokens != null && newTokens['accessToken'] != null) {
          await localDataSource.saveTokens(
            newTokens['accessToken']!,
            newTokens['refreshToken']!,
          );
          // повтор запроса с новым токеном
          return await _sendRaw(
            endpoint,
            method: method,
            headers: headers,
            body: body,
            retrying: true,
          );
        }
      }
    }

    return response;
  }

  // 🔹 Упрощённые методы
  Future<Map<String, dynamic>> postJson(String endpoint, Map<String, dynamic> body) async {
    final response = await _sendRaw(
      endpoint,
      method: 'POST',
      body: jsonEncode(body),
    );
    return _decodeOrThrow(response);
  }

  Future<Map<String, dynamic>> deleteJson(String endpoint, Map<String, dynamic> body) async {
    final response = await _sendRaw(
      endpoint,
      method: 'DELETE',
      body: jsonEncode(body),
    );
    return _decodeOrThrow(response);
  }
  
   Future<Map<String, dynamic>> putJson(String endpoint, Map<String, dynamic> body) async {
    final response = await _sendRaw(
      endpoint,
      method: 'PUT',
      body: jsonEncode(body),
    );
    return _decodeOrThrow(response);
  }

  Future<dynamic> getJson(String endpoint) async {
    final response = await _sendRaw(endpoint, method: 'GET');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // 🔹 Декодер + исключение
  Map<String, dynamic> _decodeOrThrow(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  // 🔹 Прямой refresh-запрос без middleware
  Future<Map<String, String?>?> _refreshWithHttp(String refreshToken) async {
    try {
      final uri = Uri.parse('$baseUrl/refresh');
      final resp = await httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        return {
          'accessToken': body['accessToken'] as String?,
          'refreshToken': body['refreshToken'] as String?,
        };
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);
  @override
  String toString() => 'ApiException($statusCode): $body';
}