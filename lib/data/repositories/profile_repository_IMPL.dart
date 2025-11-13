import 'package:http/http.dart';
import 'package:tik_talk/data/DTO/user_DTO.dart';
import 'package:tik_talk/data/datasources/local/users_dao.dart';
import 'package:tik_talk/data/datasources/remote/user_service_remote_source.dart';
import 'package:tik_talk/data/mapers/user_mapper.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final UsersDao usersDao;
  final UserServiceRemoteSource userRepo;
  final UserMapper userMapper;

  ProfileRepositoryImpl({
    required this.usersDao,
    required this.userRepo,
    required this.userMapper,
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
  
  @override
  Future<bool> updateUser({String? avatar, String? bio, DateTime? birthOfDay, String? userId}) async {
    try{if (await userRepo.updateUserProfile(aboutMe: bio ,avatarUrl: avatar,birthdayDate: birthOfDay)){
      if (avatar != null){
        await usersDao.updateAvatar(userId!, avatar);
      }
      if (bio != null){
        await usersDao.updateBio(userId!, bio);
      }
      if (birthOfDay != null){
        await usersDao.updateDateOfBirth(userId!, birthOfDay);
      }
      return true;
    } else{
      return false;
    }} catch (e){
      throw ('Bad try user update $e');
    }


  }


}

