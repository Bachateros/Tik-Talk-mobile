import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences prefs;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _userIdKey = 'user_id';

  AuthLocalDataSource(this.prefs);

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await prefs.setString(_accessKey, accessToken);
    await prefs.setString(_refreshKey, refreshToken);
  }

  Future<void> saveUserId(int userId) async {
    await prefs.setInt(_userIdKey, userId);
  }

  String? getAccessToken() => prefs.getString(_accessKey);
  String? getRefreshToken() => prefs.getString(_refreshKey);
  int? getUserId() => prefs.getInt(_userIdKey);

  Map<String, dynamic> getTokens() => {
        'accessToken': prefs.getString(_accessKey),
        'refreshToken': prefs.getString(_refreshKey),
        'userId': prefs.getInt(_userIdKey),
      };

  Future<void> clearTokens() async {
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_userIdKey);
  }
}