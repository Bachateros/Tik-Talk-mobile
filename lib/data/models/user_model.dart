import 'package:tik_talk/domain/entities/settings_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';

import 'package:tik_talk/domain/entities/user_entitie.dart';

class UserModel extends UserEntity {
// "ID" /нужно на пользователе
// "CreatedAt"
// "UpdatedAt"
// "DeletedAt"
// "name" /нужно на пользователе
// "surname"/нужно на пользователе
// "tgUsername"/нужно на пользователе
// "password"
  const UserModel({
    super.userId = '',
    super.name = '',
    super.surname = '',
    super.tgUsername = '',
    super.accessToken,
    super.refreshToken,
    super.accesBotLink,
    super.aboutMe,
    super.avatarUrl,
    super.birthdayDate,
    super.settings,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Безопасное чтение данных
    final id = json['ID']?.toString() ?? '';
    final name = json['name']?.toString() ?? '';
    final surname = json['surname']?.toString() ?? '';
    final tgUsername = json['tgUsername']?.toString() ?? '';
    final accessToken = json['accessToken']?.toString();
    final refreshToken = json['refreshToken']?.toString();
    final accesBotLink = json['link']?.toString();

    // Профиль
    final avatarUrl = json['avatar']?.toString() != '' 
                   || json['avatar']?.toString() != null  
                   ? json['avatar'].toString() 
                   : 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
    final aboutMe = json['bio']?.toString() ?? '';
    final birthdayDate =  json['dateOfBirth']?.toString() != null
                        ? DateTime.tryParse(json['dateOfBirth'].toString())
                        : null;

    return UserModel(
      userId: id,
      name: name,
      surname: surname,
      tgUsername: tgUsername,
      accessToken: accessToken,
      refreshToken: refreshToken,
      accesBotLink: accesBotLink,
      aboutMe: aboutMe,
      avatarUrl: avatarUrl,
      birthdayDate: birthdayDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId.isNotEmpty ? userId : null,
      'name': name.isNotEmpty ? name : null,
      'surname': surname.isNotEmpty ? surname : null,
      'tgUsername': tgUsername.isNotEmpty ? tgUsername : null,
      if (accessToken != null) 'accessToken': accessToken,
      if (refreshToken != null) 'refreshToken': refreshToken,
      if (accesBotLink != null) 'link': accesBotLink,
      // 'avatar': profile.avatarUrl.isNotEmpty
      //     ? profile.avatarUrl
      //     : 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
      // 'bio': profile.aboutMe,
      // 'date_of_birth': profile.birthdayDate?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  @override
  UserModel copyWith({
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
  }) {
    return UserModel(
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
    );
  }
}
