import 'package:tik_talk/domain/entities/user_entitie.dart';
import '../datasources/db/app_db.dart';
import 'package:tik_talk/data/DTO/user_DTO.dart';
import 'base_mapper.dart';

// "user_id"
// "name"
// "surname"
// "tgUsername"
// "avatar"
// "bio"
// "date_of_birth"

class UserMapper
    implements BaseMapper<Map<String, dynamic>, UserDTO, UserEntity, User> {
  @override
  UserDTO fromResponse(Map<String, dynamic> json) => UserDTO(
    id: json['user_id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    surname:  json['surname']?.toString() ?? '',
    tgname:  json['tgUsername']?.toString() ?? '',
    avatarUrl: json['avatar']?.toString() != '' 
                   || json['avatar']?.toString() != null  
                   ? json['avatar'].toString() 
                   : 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
    bio:json['bio']?.toString() ?? '',
    dateOfBirth:json['date_of_birth']?.toString() != null
                        ? DateTime.tryParse(json['date_of_birth'].toString())
                        : null,
    createdAt: json['CreatedAt']?.toString() != null
                        ? DateTime.tryParse(json['createdAt'].toString())
                        : null,
    deletedAt: null,
    isDeleted: false,
    updatedAt: DateTime.now(),
  );

  @override
  Map<String, dynamic> toResponse(UserDTO dto) => {
    'bio': dto.bio ,
    'avatar':dto.avatarUrl ,
    'date_of_birth': dto.dateOfBirth,
  };

  @override
  UserEntity toEntity(UserDTO dto) => UserEntity(
        userId: dto.id,
        name: dto.name,
        surname: dto.surname,
        tgUsername: dto.tgname,
        avatarUrl: dto.avatarUrl,
        aboutMe: dto.bio,
        birthdayDate: dto.dateOfBirth
      );

  @override
  UserDTO fromEntity(UserEntity e) => UserDTO(
    id: e.userId,
    name: e.name,
    surname: e.surname,
    tgname: e.tgUsername,
    dateOfBirth: e.birthdayDate,
    bio: e.aboutMe,
    avatarUrl: e.avatarUrl,
    isDeleted: false,
    createdAt: null,
    deletedAt: null,
    updatedAt: null ,
      );
      
  @override
  UserDTO toDTO(User user) {
    return UserDTO(
      id: user.id, 
      name: user.name, 
      surname: user.surname, 
      tgname:user. tgname,
      dateOfBirth:user.dateOfBirth,
      bio:user.bio,
      avatarUrl:user.avatarUrl,
      isDeleted:user.isDeleted, 
      createdAt: user.createdAt, 
      deletedAt: user.deletedAt, 
      updatedAt: user.updatedAt,
    );
  }
}
