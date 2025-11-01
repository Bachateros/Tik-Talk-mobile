// import 'package:tik_talk/data/api_remote/ApiClient.dart';
// import '../api/models/chat.dart';
// import '../api/models/participant.dart';
// import 'dart:convert';

// class ChatService{
//   final api = ApiClient();

//   Future<bool> createChat(Chat chat, Map<String,Participant> participants) async {
//     final response = await api.sendRequest(
//       '/chat/create',
//       method: 'POST',
//       body: jsonEncode({
//         'name': chat.nameChat,
//         'description': chat.descriptionChat,
//         'type': chat.typeChat,
//         'avatarUrl': chat.avatarUrl,
//         'is_private': chat.isPrivate,
//         'participants': participants,
//       })
//       );

//       if (response.statusCode == 201){
//         return true;
//       }else if (response.statusCode == 400) {
//       throw Exception("Неверные данные запроса");
//       } else if (response.statusCode == 500) {
//       throw Exception("Ошибка сервера");
//       } else {
//       return false;
//       }
//   }//+

//   Future<bool> deleteChat(int chatId) async {
//     final response = await api.sendRequest(
//       '/chat',
//       method: 'DELETE',
//       body: jsonEncode({'chat_id':chatId})
//       );

//       if (response.statusCode == 200){
//         return true;
//       }else if (response.statusCode == 400) {
//       throw Exception("Неверные данные запроса");
//       }else if (response.statusCode == 404) {
//       throw Exception("Чат не найден");
//       } else if (response.statusCode == 500) {
//       throw Exception("Ошибка сервера");
//       } else {
//       return false;
//       }
//   }//+

//   Future<String?> updateChat(Chat chat) async {
//     final response = await api.sendRequest(
//       '/chat',
//       method: 'PUT',
//       body: jsonEncode({
//         'chat_id':chat.idChat,
//         'name':chat.nameChat,
//         'description':chat.descriptionChat,
//         'avatarUrl':chat.avatarUrl,
//         'is_private':chat.isPrivate,
//         })
//       );

//       if (response.statusCode == 200){
//         final body = jsonDecode(response.body);
//         return body['chat_id'] as String?;
//       }else if (response.statusCode == 400) {
//       throw Exception("Неверные данные запроса");
//       }else if (response.statusCode == 404) {
//       throw Exception("Чат не найден");
//       } else if (response.statusCode == 500) {
//       throw Exception("Ошибка сервера");
//       } else {
//       return null;
//       }
//   }//+    

//   Future<bool> getChats() async {
//     final response = await api.sendRequest(
//       '/chats',
//       method: 'GET',
//       );

//       if (response.statusCode == 200){
//         return true;
//       } else if (response.statusCode == 500) {
//       throw Exception("Ошибка сервера");
//       } else {
//       return false;
//       }
//   }//+

//   Future<bool> getListChats() async {
//     final response = await api.sendRequest(
//       '/chats/all',
//       method: 'GET',
//       );

//       if (response.statusCode == 200){
//         return true;
//       }else if (response.statusCode == 403) {
//       throw Exception("Недостаточно прав");
//       } else if (response.statusCode == 500) {
//       throw Exception("Ошибка сервера");
//       } else {
//       return false;
//       }
//   }//+

//   Future<Chat?> searchChat(String search) async {
//     final endpoint = '/chats/search?name=${Uri.encodeComponent(search)}';
    
//     final response = await api.sendRequest(
//       endpoint,
//       method: 'GET',
//       );

//       if (response.statusCode == 200){
//         final body = jsonDecode(response.body);
//         return Chat.fromJson(body);
//       }else if (response.statusCode == 400) {
//       throw Exception("Неверные данные запроса");
//       } else if (response.statusCode == 500) {
//       throw Exception("Ошибка сервера");
//       } else {
//       return null;
//       }
//   }//+

//   Future<bool> addParticChat(int userId, int chatId) async {
//     final response = await api.sendRequest(
//       '/chat/add',
//       method: 'POST',
//       body: jsonEncode({
//         'chat_id': chatId,
//         'user_id': userId,
//         })
//       );

//       if (response.statusCode == 200){
//         return true;
//       } else if (response.statusCode == 400) {
//       throw Exception("Неверные данные запроса");
//       } else if (response.statusCode == 403) {
//       throw Exception("Недостаточно прав для добавления участника");
//       } else if (response.statusCode == 404) {
//       throw Exception("Чат или пользователь не найден");
//       } else if (response.statusCode == 500) {
//       throw Exception("Ошибка сервера");
//       } else {
//       return false;
//       }
//   }//+

//   Future<List<Participant>?> getChatParticipants(String chatId) async {
//     final response = await api.sendRequest(
//       '/chat/participants?chat_id=$chatId',
//       method: 'GET',
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> body = jsonDecode(response.body);
//       return body.map((item) => Participant.fromJson(item)).toList();
//     } else if (response.statusCode == 400) {
//       throw Exception("Неверные параметры запроса");
//     } else if (response.statusCode == 401) {
//       throw Exception("Неавторизованный доступ");
//     } else if (response.statusCode == 404) {
//       throw Exception("Чат не найден");
//     } else if (response.statusCode == 500) {
//       throw Exception("Внутренняя ошибка сервера");
//     } else {
//       throw Exception("Неизвестная ошибка: ${response.statusCode}");
//     }
//   }//+

//   Future<bool> leaveChat(String chatId, String userId) async {
//     final response = await api.sendRequest(
//       '/chat/leave',
//       method: 'POST',
//       body: jsonEncode({
//         'chat_id': chatId,
//         'user_id': userId,
//       })
//       );

//       if (response.statusCode == 200){
//         return true;
//       }else if (response.statusCode == 400) {
//       throw Exception("Неверные данные запроса");
//       } else if (response.statusCode == 404) {
//       throw Exception("Чат или участник не найден");
//       } else if (response.statusCode == 500) {
//       throw Exception("Ошибка сервера");
//       } else {
//       return false;
//       }
//   }//+
  
//   Future<bool> delParticChat(String chatId, String userId) async {
//     final response = await api.sendRequest(
//       '/chat/remove',
//       method: 'DELETE',
//       body: jsonEncode({
//         'chat_id': chatId,
//         'user_id': userId,
//       })
//       );

//       if (response.statusCode == 200){
//         return true;
//       }else if (response.statusCode == 400) {
//       throw Exception("Неверные данные запроса");
//       }else if (response.statusCode == 403) {
//       throw Exception("Недостаточно прав для изменения роли");
//       } else if (response.statusCode == 404) {
//       throw Exception("Чат или участник не найден");
//       } else if (response.statusCode == 500) {
//       throw Exception("Ошибка сервера");
//       } else {
//       return false;
//       }
//   }//+

//   Future<bool> updateRoleParticChat(String chatId, String userId, String role) async {
//     final response = await api.sendRequest(
//       '/chat/participant',
//       method: 'PUT',
//       body: jsonEncode({
//         'chat_id': chatId,
//         'user_id': userId,
//         'role': role,
//       })
//       );
//       if (response.statusCode == 200){
//         return true;
//       }else if (response.statusCode == 400) {
//       throw Exception("Неверные данные запроса");
//       } else if (response.statusCode == 403) {
//       throw Exception("Недостаточно прав для изменения роли");
//       } else if (response.statusCode == 404) {
//       throw Exception("Чат или участник не найден");
//       } else if (response.statusCode == 500) {
//       throw Exception("Ошибка сервера");
//       } else {
//       return false;
//       }
//   }    
// }

