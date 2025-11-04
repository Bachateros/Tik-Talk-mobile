part of 'chat_bloc.dart';

class ChatState {
  final ChatStatus status;
  final List<ParticipantEntitie>? listChatUsres;
  final String? selectedChatId;
  final ChatEntitie? chatModel;//selected chat in HomeState
  final String? errorMessage;
  
  const ChatState({
    required this.status,
    this.listChatUsres = const[],
    this.chatModel,
    this.selectedChatId,
    this.errorMessage,
  });

  factory ChatState.initial() =>
    ChatState(status: ChatStatus.unknown);

  ChatState copyWith(
    ChatStatus? status,
    List<ParticipantEntitie>? listChatUsres,
    String? selectedChatId,
    ChatEntitie? chatModel,
    String? errorMessage,
  ){
    return ChatState(
      status: status ?? this.status,
      listChatUsres: listChatUsres ?? this.listChatUsres,
      selectedChatId: selectedChatId ?? this.selectedChatId,
      chatModel: chatModel ?? this.chatModel,
      errorMessage: errorMessage ?? this.errorMessage,
      );
  }
}

enum ChatStatus{
  unknown,
  selected,
  create,
  delete,
  change,
}