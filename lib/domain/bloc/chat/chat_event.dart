part of 'chat_bloc.dart';

abstract class ChatEvent{}

//ChatPage
class LoadChatEvent extends ChatEvent{
  final String chatId;
  LoadChatEvent({required this.chatId}); //обновляем данные по id (здесь именно чат и участники)
}

class UpdateEvent extends ChatEvent{} //обновляем после отправки или получения сообщения должен срабатывать при изменении с данными
                                      //обновление всего чата
class LoadMessagesEvent extends ChatEvent{}//загрузка сообщений (здесь только сообщения)

class SendMessageEvent extends ChatEvent{
  final MessageEntitie message;
  SendMessageEvent({required this.message});
}

//пока не знаю будет ли работать
class UpdateMessegeEvent extends ChatEvent{ //удаление сообщения или его изменение для этого можно добавить флаг сообщению что оно удалено или изменено
  final MessageEntitie message;
  UpdateMessegeEvent({required this.message});
}

// Инициализаци личного чата direct в котором есть только мы
class CreateDirectEvent extends ChatEvent{ //создание личного чата сделано автоматически новым
  final ChatEntitie chat;
  CreateDirectEvent({required this.chat});
}
class StatusChangeEvent extends ChatEvent{
  final ChatStatus status;
  StatusChangeEvent({required this.status});
}
//ChatPage/Settings
class DeleteChatEvent extends ChatEvent{} //удалить чат из памяти автоматический Leave из него (подходит для direct)

class LeaveFromChat extends ChatEvent{} //выход из чата без удаления (для каналов и бесед)

// это для CreatePage
class CreateChatEvent extends ChatEvent{ //создание чата
  final ChatEntitie chat;
  final List<ParticipantEntitie?> participantList;
  CreateChatEvent({required this.chat,required this.participantList});
}