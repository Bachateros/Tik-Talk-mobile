part of 'chat_bloc.dart';

class ChatState {
  final ChatStatus status;
  final List<ParticipantEntitie?> listParticipant;
  final List<MessageEntitie?> listMesseges;
  final String? chatId;
  final ChatEntitie? chatModel;//selected chat in HomeState
  final String? errorMessage;
  
  const ChatState({
    required this.status,
    this.listParticipant = const[],
    this.listMesseges = const[],
    this.chatModel,
    this.chatId,
    this.errorMessage,
  });

  factory ChatState.initial() =>
    ChatState(status: ChatStatus.unknown);

  ChatState copyWith({
    ChatStatus? status,
    List<ParticipantEntitie>? listParticipant,
    List<MessageEntitie?>? listMesseges,
    String? chatId,
    ChatEntitie? chatModel,
    String? errorMessage,
    }
  ){
    return ChatState(
      status: status ?? this.status,
      listParticipant: listParticipant ?? this.listParticipant,
      chatId: chatId ?? this.chatId,
      listMesseges: listMesseges ?? this.listMesseges,
      chatModel: chatModel ?? this.chatModel,
      errorMessage: errorMessage ?? this.errorMessage,
      );
  }
}

enum ChatStatus{
  unknown,
  update,
  failure
}