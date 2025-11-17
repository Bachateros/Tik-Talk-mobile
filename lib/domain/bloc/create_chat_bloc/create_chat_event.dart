part of 'create_chat_bloc.dart';

abstract class CreateChatEvent{}

class CreateNewChatEvent extends CreateChatEvent{
  List<ParticipantEntitie?> listParticipant;
  ChatEntitie chat;
  CreateNewChatEvent({required this.chat,required this.listParticipant});
}

class SwitchCreateChatEvent extends CreateChatEvent{
  CreateChatStatus status;
  SwitchCreateChatEvent({required this.status});
}