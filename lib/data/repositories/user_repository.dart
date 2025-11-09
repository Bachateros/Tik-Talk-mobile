import 'package:shared_preferences/shared_preferences.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';

// class UserRepository {
//   final SharedPreferences _sharedPreferences;

//   const UserRepository({required SharedPreferences sharedPreferences}) : _sharedPreferences = sharedPreferences;

//   UserEntity? _user;

//   UserEntity? get user => _user;

//   Future<void> loadUser() async {
//     if (!_sharedPreferences.containsKey('user')) {
//       return;
//     }

//     _user = _sharedPreferences.get('user') as UserEntity?;
//   }

//   Future<void> updateUser({required UserEntity user}) async {
//     _user = user;

//     _sharedPreferences.
//   }
// }