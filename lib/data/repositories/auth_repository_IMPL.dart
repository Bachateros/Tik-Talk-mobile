import 'package:tik_talk/domain/repositories/auth_repository.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/data/datasources/local/auth_local_data_source.dart';
import 'package:tik_talk/data/datasources/remote/auth_service_remote_data_source.dart';
import 'package:tik_talk/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<UserEntity> login(String tgUsername, String password) async {
    final resp = await remote.login(tgUsername, password);

    if (resp.isEmpty || resp.containsKey('error')) {
      throw Exception(resp['error'] ?? 'Ошибка логина');
    }
    // if server returns user_id only:
    final userId =
        resp['user_id'] is int
            ? resp['user_id'] as int
            : (resp['user_id'] != null
                ? int.tryParse(resp['user_id'].toString())
                : null);

    // NOTE: If server returns tokens here — save them. If not, tokens will come after verify.
    final access = resp['accessToken'] as String?;
    final refresh = resp['refreshToken'] as String?;

    if (access != null && refresh != null) {
      await local.saveTokens(access, refresh);
    }

    if (userId != null) {
      await local.saveUserId(userId);
    }

    final user = UserModel(
      userId: userId,
      tgUsername: tgUsername,
      name: resp['name'] as String?,
      surname: resp['surname'] as String?,
      accessToken: access,
      refreshToken: refresh,
    );

    return user;
  }

  @override
  Future<UserEntity> register(
    String surname,
    String name,
    String tgUsername,
    String password,
  ) async {
    final resp = await remote.register(name, surname, tgUsername, password);
    final user = UserModel(
      name: name,
      surname: surname,
      tgUsername: tgUsername,
      accesBotLink: resp['link'],
    );
    return user;
  }

  @override
  Future<UserEntity> verify(int userId, String code) async {
    final resp = await remote.verify(userId, code);
    // expected to return accessToken and refreshToken
    final access = resp['accessToken'] as String?;
    final refresh = resp['refreshToken'] as String?;

    if (access == null || refresh == null) {
      throw Exception('Verify did not return tokens');
    }

    await local.saveTokens(access, refresh);
    final int? userIdInt = userId;

    if (userIdInt != null) {
      await local.saveUserId(userIdInt);
    }

    final user = UserModel(
      userId: userIdInt,
      accessToken: access,
      refreshToken: refresh,
    );
    return user;
  }

  @override
  Future<void> logout() async {
    // Optionally notify server
    final access = await local.getAccessToken();
    if (access != null) {
      try {
        await remote.logout(access);
      } catch (_) {
        // ignore remote logout errors and continue clearing local tokens
      }
    }
    await local.clearTokens();
  }

  @override
  Future<UserEntity?> refreshToken() async {
    final refresh = await local.getRefreshToken();
    if (refresh == null) return null;

    try {
      final resp = await remote.refresh(refresh);
      final access = resp['accessToken'] as String?;
      final refreshNew = resp['refreshToken'] as String?;
      if (access != null && refreshNew != null) {
        await local.saveTokens(access, refreshNew);
        final userId = await local.getUserId();
        return UserModel(
          userId: userId,
          accessToken: access,
          refreshToken: refreshNew,
        );
      }
      return null;
    } catch (_) {
      // refresh failed
      await local.clearTokens();
      return null;
    }
  }

  @override
  Future<bool> hasValidTokens() async {
    final resp = await local.getTokens();

    final access = resp['accessToken'];
    final refresh = resp['refreshToken'];
    final userId = resp['userId'];

    if (access != null && refresh != null && userId != null) {
      return true;
    } else {
      return false;
    }
  }
}
