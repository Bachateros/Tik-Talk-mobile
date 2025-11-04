part of 'home_bloc.dart';

abstract class HomeEvent {}

class LoadEvent extends HomeEvent{} //синхронизация чатов

class SelectChatEvent extends HomeEvent{ //выбор чата для изменения, удаление
  final ChatEntitie selectedChat;
  SelectChatEvent({required this.selectedChat});
}

class UpdateEvent extends HomeEvent{} //обновление чатов на домашней странице





