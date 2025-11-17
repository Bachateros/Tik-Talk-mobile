import 'package:tik_talk/domain/repositories/auth_repository.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/data/datasources/remote/auth_service_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl({
    required this.remote,
    required this.local,
  });

  /// ---------- LOGIN ----------
  @override
  Future<UserEntity> login(String tgUsername, String password) async {
    final resp = await remote.login(tgUsername: tgUsername, password: password);

    if (resp.isEmpty || resp.containsKey('error')) {
      throw Exception(resp['error'] ?? 'Ошибка логина');
    }

    final userId = resp['user_id']?.toString();
    final access = resp['accessToken'] as String?;
    final refresh = resp['refreshToken'] as String?;

    if (access != null && refresh != null) {
      await local.saveTokens(access, refresh);
    }

    if (userId != null) {
      await local.saveUserId(userId);
    }

    return UserEntity(
      userId: userId ?? '',
      tgUsername: tgUsername,
      name: resp['name']?.toString() ?? '',
      surname: resp['surname']?.toString() ?? '',
      accessToken: access,
      refreshToken: refresh,
      );
  }

  /// ---------- REGISTER ----------
  @override
  Future<UserEntity> register(
    String surname,
    String name,
    String tgUsername,
    String password,
  ) async {
    final resp = await remote.register(
      surname: surname,
      name: name,
      tgUsername: tgUsername,
      password: password,
    );

    return UserEntity(
      name: name,
      surname: surname,
      tgUsername: tgUsername,
      accesBotLink: resp['link']?.toString(),
    );
  }

  /// ---------- VERIFY ----------
  @override
  Future<UserEntity> verify(String userId, String code) async {
    final resp = await remote.verify(userId: userId, code: code);

    final access = resp['accessToken'] as String?;
    final refresh = resp['refreshToken'] as String?;

    if (access == null || refresh == null) {
      throw Exception('Verify did not return tokens');
    }

    await local.saveTokens(access, refresh);
    await local.saveUserId(userId);

    return UserEntity(
      userId: userId,
      accessToken: access,
      refreshToken: refresh,
    );
  }

  /// ---------- LOGOUT ----------
  @override
  Future<void> logout() async {
    final access = await local.getAccessToken();
    if (access != null) {
      try {
        await remote.logout(accessToken: access);
      } catch (_) {
        // игнорируем ошибку при logout на сервере
      }
    }
    // final id = await local.getUserId();
    // await DIContainer().deleteUserDb(id!);

    await local.clearTokens();
  }

  /// ---------- REFRESH TOKEN ----------
  @override
  Future<UserEntity?> refreshToken() async {
    final refresh = await local.getRefreshToken();
    if (refresh == null) return null;

    try {
      final resp = await remote.refresh(refreshToken: refresh);
      final access = resp['accessToken'] as String?;
      final refreshNew = resp['refreshToken'] as String?;

      if (access != null && refreshNew != null) {
        await local.saveTokens(access, refreshNew);
        final userId = await local.getUserId();
        return UserEntity(
          userId: userId!,
          accessToken: access,
          refreshToken: refreshNew,
        );
      }
      return null;
    } catch (_) {
      await local.clearTokens();
      return null;
    }
  }

  /// ---------- CHECK TOKENS ----------
  @override
  Future<String?> hasValidTokens() async {
    final resp = await local.getTokens();
    final access = resp['accessToken'];
    final refresh = resp['refreshToken'];
    final userId = resp['userId'];
    
    if (access != null && refresh != null && userId != null) {
      return userId;
    }

    return null;
  }
}
