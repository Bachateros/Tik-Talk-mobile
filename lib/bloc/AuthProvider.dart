import 'package:flutter/material.dart';
import 'package:tik_talk/models/user.dart';
import 'package:tik_talk/service/auth.dart';
import 'package:tik_talk/service/TokenStorage.dart';

class AuthProvider extends ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;
  User? _user;

  final AuthService _authService = AuthService();

  bool get isAuth => _refreshToken != null;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  User? get user => _user;

  Future<void> init() async {
    final tokens = await TokenStorage.getTokens();
    _accessToken = tokens['access'];
    _refreshToken = tokens['refresh'];
    notifyListeners();
  }

  Future<String?> loginStep1(String telNumber) async {
    final result = await _authService.login1(telNumber);
    return result;
  }

  Future<bool> loginStep2(String code) async {
    final Map<String, dynamic>? resp = await _authService.login2(code);

    if (resp != null) {
      final String? access = resp['access'] as String?;
      final String? refresh = resp['refresh'] as String?;
      
      if (access == null || refresh == null) {
        debugPrint('loginStep2: tokens missing in response');
        return false;
      }

      await TokenStorage.saveTokens(access, refresh);

      _accessToken = access;
      _refreshToken = refresh;

      _user = User.fromJson(resp);

      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    await TokenStorage.clearTokens();
    _accessToken = null;
    _refreshToken = null;
    _user = null;
    notifyListeners();
  }
}