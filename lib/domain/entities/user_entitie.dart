import 'package:tik_talk/domain/entities/settings_entitie.dart';

class UserEntity {
  final String userId;
  final String name;
  final String surname;
  final String tgUsername;
  final String? accessToken;
  final String? refreshToken;
  final String? accesBotLink;
  final String? avatarUrl;
  final String? aboutMe;
  final DateTime? birthdayDate;
  final SettingsEntitie? settings;
  final String? clientId;

  const UserEntity({
    this.userId = '',
    this.name = '',
    this.surname = '',
    this.tgUsername = '',
    this.accessToken,
    this.refreshToken,
    this.accesBotLink,
    this.avatarUrl,
    this.aboutMe = '',
    this.birthdayDate,
    this.settings,
    this.clientId,
  });

  UserEntity copyWith({
    String? userId,
    String? name,
    String? surname,
    String? tgUsername,
    String? accessToken,
    String? refreshToken,
    String? accesBotLink,
    String? avatarUrl,
    String? aboutMe,
    DateTime? birthdayDate,
    SettingsEntitie? settings,
    String? clientId,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      tgUsername: tgUsername ?? this.tgUsername,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accesBotLink: accesBotLink ?? this.accesBotLink,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      aboutMe: aboutMe ?? this.aboutMe ,
      birthdayDate: birthdayDate ?? this.birthdayDate,
      settings: settings ?? this.settings,
      clientId: clientId ?? this.clientId,
    );
  }
}
