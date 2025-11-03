class UserEntity {
  final int? userId;
  final String? name;
  final String? surname;
  final String? tgUsername;
  final String? accessToken;
  final String? refreshToken;
  final String? accesBotLink;
  
  const UserEntity({
    this.userId,
    this.name,
    this.surname,
    this.tgUsername,
    this.accessToken,
    this.refreshToken,
    this.accesBotLink,
  });

  UserEntity copyWith({
    int? userId,
    String? name,
    String? surname,
    String? tgUsername,
    String? accessToken,
    String? refreshToken,
    String? accesBotLink,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      tgUsername: tgUsername ?? this.tgUsername,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      accesBotLink: accesBotLink ?? this.accesBotLink,
    );
  }
}