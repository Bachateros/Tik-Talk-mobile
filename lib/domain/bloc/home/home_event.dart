part of 'home_bloc.dart';

abstract class HomeEvent {}

class LoadEvent extends HomeEvent{} //синхронизация чатов
class UpdateEvent extends HomeEvent{} //обновление чатов на домашней странице

class UpdateClientIdWS extends HomeEvent {
  final String clientId;
  UpdateClientIdWS(this.clientId);
}



