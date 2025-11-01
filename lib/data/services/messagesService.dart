// import 'dart:convert';

// import '../api/models/messege.dart';
// import 'package:tik_talk/data/api_remote/ApiClient.dart';

// class MessageService{
//   final api = ApiClient();
  
//   Future <bool> sendMessege(Message message) async {
//     final response = await api.sendRequest(
//       '/message/send',
//       method: 'POST',
//       body: message.toJson(),
//     );
    
//     if (response.statusCode == 201){
//       return true;
//     } else if (response.statusCode == 400) {
//     throw Exception("Неверные данные запроса");
//     } else if (response.statusCode == 404) {
//     throw Exception("Чат не найден");
//     } else if (response.statusCode == 500) {
//     throw Exception("Ошибка сервера");
//     } else {
//     return false;
//     }
//   }

//   Future <List <Message>?> getMessege( String chatId,) 
//   async {
//     int limit = 50, offset = 0;
//     final endpoint = '/chat/messages'
//       '?chat_id=$chatId'
//       '&limit=$limit'
//       '&offset=$offset';
//     final response = await api.sendRequest(
//       endpoint,
//       method: 'Get',
//     );
    
//     if (response.statusCode == 200){
//       final body = jsonDecode(response.body);
//       if (body is List) {
//         return body.map((item) => Message.fromJson(item)).toList();
//       } else {
//         throw Exception("Неверный формат данных от сервера");
//       }
//     } else if (response.statusCode == 400) {
//     throw Exception("Неверные данные запроса");
//     } else if (response.statusCode == 404) {
//     throw Exception("Чат не найден");
//     } else if (response.statusCode == 500) {
//     throw Exception("Ошибка сервера");
//     } else {
//     return null;
//     }
//   }
// }
