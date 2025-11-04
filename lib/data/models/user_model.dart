import 'package:tik_talk/domain/entities/user_entitie.dart';

class UserModel extends UserEntity {
  const UserModel({
    int? userId,
    String? name,
    String? surname,
    String? tgUsername,
    String? accessToken,
    String? refreshToken,
    String? accesBotLink,
  }) : super(
          userId: userId,
          name: name,
          surname: surname,
          tgUsername: tgUsername,
          accessToken: accessToken,
          refreshToken: refreshToken,
          accesBotLink: accesBotLink,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'] as int?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      tgUsername: json['tg_username'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      accesBotLink: json['link'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': name,
      'surname': surname,
      'tg_username': tgUsername,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'link':accesBotLink,
    };
  }

  @override
  UserModel copyWith({
    int? userId,
    String? name,
    String? surname,
    String? tgUsername,
    String? accessToken,
    String? refreshToken,
    String? accesBotLink,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      surname: surname ?? this.name,
      tgUsername: tgUsername ?? this.tgUsername,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accesBotLink: accessToken ?? this.accesBotLink,
    );
  }
}
