import 'TokenStorage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  String? accessToken;
  String? refreshToken;

  final String baseUrl="http://localhost:8080";

  Future<http.Response> sendRequest(
  String endpoint, {
  String method = 'GET',
  Map<String, String>? headers,
  Object? body,
  }) async {
    final tokens = await TokenStorage.getTokens();
    final accessToken = tokens['accessToken'];
    final effectiveHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      ...?headers,
      };

    final url = Uri.parse('$baseUrl$endpoint');
    http.Response response;

    switch (method) {
      case 'GET':
        response = await http.get(url, headers: effectiveHeaders);
        break;
      case 'POST':
        response = await http.post(url, headers: effectiveHeaders, body: body);
        break;
      case 'PUT':
        response = await http.put(url, headers: effectiveHeaders, body: body);
        break;
      case 'DELETE':
        response = await http.delete(url, headers: effectiveHeaders);
        break;
      default:
        throw Exception('Метод не поддерживается');
    }

    if (response.statusCode == 401 && refreshToken != null) {
      final refreshed = await _refreshTokens();
      if (refreshed) {
        return await sendRequest(
          endpoint,
          method: method,
          headers: headers,
          body: body,
        );
      }
    }

    return response;
  }

  Future<bool> _refreshTokens() async {
    final tokens = await TokenStorage.getTokens();
    refreshToken = tokens['refresh'];
    final response = await http.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String _accessToken = data['accessToken'];
      String _refreshToken = data['refreshToken'];
      TokenStorage.saveTokens(_accessToken, _refreshToken);
      return true;
    }

    accessToken = null;
    refreshToken = null;
    return false;
  }
}
