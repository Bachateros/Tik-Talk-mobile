import 'package:drift/drift.dart';
import 'package:tik_talk/data/DTO/user_DTO.dart';
import '../db/app_db.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDb> with _$UsersDaoMixin {
  UsersDao(AppDb db) : super(db);

  Future<void> insertOrUpdate(UserDTO userDTO) async {
    final now = DateTime.now();
    await into(users).insertOnConflictUpdate(
      UsersCompanion(
        id: Value(userDTO.id),
        name: Value(userDTO.name),
        surname: Value(userDTO.surname),
        tgname: Value(userDTO.tgname),
        dateOfBirth: Value(userDTO.dateOfBirth),
        bio: Value(userDTO.bio),
        avatarUrl: Value(userDTO.avatarUrl),
        isDeleted: Value(false),
        updatedAt: Value(now),
        deletedAt: Value(userDTO.deletedAt),

      ),
    );
  }
  
  Future<List<User>> getAllUsers() => select(users).get();

  // Добавить пользователей (список)
  Future<void> insertUsers(List<UsersCompanion> entries) async {
    await batch((b) => b.insertAllOnConflictUpdate(users, entries));
  }

  // Достать пользователя по id
  Future<User?> getUserById(String id) async {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  // Достать пользователей по списку id
  Future<List<User>> getUsersByIds(List<String> ids) async {
    return (select(users)..where((u) => u.id.isIn(ids))).get();
  }

  // Обновить bio
  Future<int> updateBio(String id, String bio) async {
    return (update(users)..where((u) => u.id.equals(id)))
        .write(UsersCompanion(bio: Value(bio), updatedAt: Value(DateTime.now())));
  }

  // Обновить avatarUrl
  Future<int> updateAvatar(String id, String avatarUrl) async {
    return (update(users)..where((u) => u.id.equals(id)))
        .write(UsersCompanion(avatarUrl: Value(avatarUrl), updatedAt: Value(DateTime.now())));
  }

    // Обновить avatarUrl
  Future<int> updateDateOfBirth(String id, DateTime dateOfBirth) async {
    return (update(users)..where((u) => u.id.equals(id)))
        .write(UsersCompanion(dateOfBirth: Value(dateOfBirth), updatedAt: Value(DateTime.now())));
  }

  // Обновить дату пользователя (updatedAt)
  Future<int> touchUser(String id) async {
    return (update(users)..where((u) => u.id.equals(id)))
        .write(UsersCompanion(updatedAt: Value(DateTime.now())));
  }
}
