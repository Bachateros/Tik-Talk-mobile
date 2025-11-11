class UserResponse {

}

  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   // Безопасное чтение данных
  //   final id = json['ID']?.toString() ?? '';
  //   final name = json['name']?.toString() ?? '';
  //   final surname = json['surname']?.toString() ?? '';
  //   final tgUsername = json['tgUsername']?.toString() ?? '';
  //   final accessToken = json['accessToken']?.toString();
  //   final refreshToken = json['refreshToken']?.toString();
  //   final accesBotLink = json['link']?.toString();

  //   // Профиль
  //   final avatarUrl = json['avatar']?.toString() != '' 
  //                  || json['avatar']?.toString() != null  
  //                  ? json['avatar'].toString() 
  //                  : 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  //   final aboutMe = json['bio']?.toString() ?? '';
  //   final birthdayDate =  json['dateOfBirth']?.toString() != null
  //                       ? DateTime.tryParse(json['dateOfBirth'].toString())
  //                       : null;

  //   return UserModel(
  //     userId: id,
  //     name: name,
  //     surname: surname,
  //     tgUsername: tgUsername,
  //     accessToken: accessToken,
  //     refreshToken: refreshToken,
  //     accesBotLink: accesBotLink,
  //     aboutMe: aboutMe,
  //     avatarUrl: avatarUrl,
  //     birthdayDate: birthdayDate,
  //   );
  // }