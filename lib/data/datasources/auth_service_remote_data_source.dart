import '../services/auth_service.dart';

class AuthRemoteDataSource {
  final AuthService service;

  AuthRemoteDataSource({required this.service});

  /// register returns the raw server map (may contain link and result)
  Future<Map<String, dynamic>> register(
    String name,
    String surname,
    String tgUsername,
    String password,
  ) {
    return service.register(
      name: name,
      surname: surname,
      tgUsername: tgUsername,
      password: password,
    );
  }

  /// login expected to return either { "user_id": n } or { "error": "..."} per your API
  Future<Map<String, dynamic>> login(String tgUsername, String password) {
    return service.login(tgUsername: tgUsername, password: password);
  }

  /// verify returns tokens
  Future<Map<String, dynamic>> verify(int userId, String code) {
    return service.verify(userId: userId, code: code);
  }

  /// convenience: call refresh via service
  Future<Map<String, dynamic>> refresh(String refreshToken) {
    return service.refresh(refreshToken: refreshToken);
  }

  /// convenience: logout via service
  Future<Map<String, dynamic>> logout(String accessToken) {
    return service.logout(accessToken: accessToken);
  }
}
