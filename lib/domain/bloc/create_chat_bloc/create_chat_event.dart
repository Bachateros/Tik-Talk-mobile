part of 'create_chat_bloc.dart';

abstract class CreateChatEvent{}

class CreateNewDirectEvent extends CreateChatEvent{}
class CreateNewChatEvent extends CreateChatEvent{}