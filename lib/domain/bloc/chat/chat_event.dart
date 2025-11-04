part of 'chat_bloc.dart';

abstract class ChatEvent{}

class ChangeChatEvent extends ChatEvent{} //изменение выбраного чата

class CreateChatEvent extends ChatEvent{ //создание чата
  final ChatEntitie chat;
  CreateChatEvent({required this.chat});
}

class CreateDirectEvent extends ChatEvent{ //создание личного чата сделано автоматически новым
  final ChatEntitie chat;
  CreateDirectEvent({required this.chat});
}

class GetSelectedChatEvent extends ChatEvent{ //получить данные с которым работаем для изменения (участники чата тоже)
  final String chatId;
  GetSelectedChatEvent({required this.chatId});
}

class DeleteChatEvent extends ChatEvent{} //удалить чат из памяти автоматический Leave из него (подходит для direct)

class LeaveFromChat extends ChatEvent{} //выход из чата без удаления (для каналов и бесед)

class AddParticipantEvent extends ChatEvent{} //добавить участника

class UpdateParticipantEvent extends ChatEvent{} //обновить роль участника 

class DeleteParticipantEvent extends ChatEvent{} //удалить участника

