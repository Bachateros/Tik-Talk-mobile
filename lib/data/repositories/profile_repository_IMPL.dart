import 'package:tik_talk/data/DTO/user_DTO.dart';
import 'package:tik_talk/data/datasources/local/users_dao.dart';
import 'package:tik_talk/data/mapers/user_mapper.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final UsersDao usersDao;
  final UserMapper userMapper = UserMapper();

  ProfileRepositoryImpl({
    required this.usersDao,
  });

  @override
  Future<UserEntity> getUser(String userId) async {
    final user = await usersDao.getUserById(userId);
    if (user == null) throw Exception('User not found');

    final dto = UserDTO(
      id: user.id,
      name: user.name,
      surname: user.surname,
      tgname: user.tgname,
      bio: user.bio,
      avatarUrl: user.avatarUrl,
      isDeleted: user.isDeleted,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      deletedAt: user.deletedAt,
    );

    return userMapper.toEntity(dto);
  }


}

