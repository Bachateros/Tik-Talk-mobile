import 'package:tik_talk/domain/entities/settings_entitie.dart';

class UserEntity {
  final String? userId;
  final String? name;
  final String? surname;
  final String? tgUsername;
  final String? accessToken;
  final String? refreshToken;
  final String? accesBotLink;
  final Profile? profile;

  
  const UserEntity({
    this.userId,
    this.name,
    this.surname,
    this.tgUsername,
    this.accessToken,
    this.refreshToken,
    this.accesBotLink,
    this.profile
  });

  UserEntity copyWith({
    String? userId,
    String? name,
    String? surname,
    String? tgUsername,
    String? accessToken,
    String? refreshToken,
    String? accesBotLink,
    Profile? profile,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      tgUsername: tgUsername ?? this.tgUsername,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accesBotLink: accesBotLink ?? this.accesBotLink,
      profile: profile ?? this.profile,
    );
  }
}

class Profile{
  final String? avatarUrl;
  final String? aboutMe;
  final DateTime? birthdayDate;
  final SettingsEntitie? settings;

  Profile({
    this.avatarUrl,
    this.aboutMe,
    this.birthdayDate,
    this.settings,
  });
}