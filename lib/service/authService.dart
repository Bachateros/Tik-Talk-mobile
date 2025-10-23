import 'package:tik_talk/service/ApiClient.dart';
import 'dart:convert';

class AuthService{
  Future<String?> login1(String telNumber) async {
      final api = ApiClient();
      final response = await api.sendRequest(
        '/login',
        method: 'POST',
        body: jsonEncode({'telNumber': telNumber})   
        );

      if (response.statusCode == 200) {
        return response.statusCode as String?;
      } else if (response.statusCode == 400){
            return "Неверные данные запроса";
      } else if (response.statusCode == 500){
            return "Внутренняя ошибка сервера";
      } else{      
        return null;
      }
    }

  Future<Map<String, String>?> login2(String code) async {
      final api = ApiClient();
      final response = await api.sendRequest(
        '/login/verify',
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}), 
        );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return {
          'access': body['accessToken'],
          'refresh': body['refreshToken'],
          'name': body['name'],
          'surname': body['surname'],
          'telNumber' : body['telNumber'],
          'tg_username' : body['tg_username']
        };
      } else if (response.statusCode == 400) {
        throw Exception("Неверные данные запроса");
      } else if (response.statusCode == 500) {
        throw Exception("Ошибка сервера");
      } else {
        return null;
      }
    }

    Future<bool?> register (String name,String surname,String telNumber, String password, String tgUsername) async{
      final api = ApiClient();
      final response = await api.sendRequest(
        '/register',
        method: "POST",
        body: jsonEncode({
          'name': name, 
          'surname': surname, 
          'telNumber': telNumber, 
          'password': password,
          'tg_username': tgUsername
          })
        );

      if (response.statusCode==200){
        return true;
      }else if (response.statusCode == 400) {
      throw Exception("Неверные данные запроса");
      } else if (response.statusCode == 500) {
      throw Exception("Ошибка сервера");
      } else {
      return null;
      }
    }
}
