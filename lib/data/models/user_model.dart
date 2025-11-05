import 'package:tik_talk/domain/entities/user_entitie.dart';

class UserModel extends UserEntity {
  const UserModel({
    String? userId,
    String? name,
    String? surname,
    String? tgUsername,
    String? accessToken,
    String? refreshToken,
    String? accesBotLink,
    Profile? profile,
  }) : super(
          userId: userId,
          name: name,
          surname: surname,
          tgUsername: tgUsername,
          accessToken: accessToken,
          refreshToken: refreshToken,
          accesBotLink: accesBotLink,
          profile: profile,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      tgUsername: json['tg_username'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      accesBotLink: json['link'] as String?,
      //TODO:Profile
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
      //TODO:Profile
    };
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
    Profile? profile,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      surname: surname ?? this.name,
      tgUsername: tgUsername ?? this.tgUsername,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accesBotLink: accessToken ?? this.accesBotLink,
      profile: profile ?? this.profile,
    );
  }
}
