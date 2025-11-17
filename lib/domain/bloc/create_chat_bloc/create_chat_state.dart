part of 'create_chat_bloc.dart';

class CreateChatState {
  final CreateChatStatus status;
  final String? errorMessage;
  final List<UserEntity?>  listUsers;
  final List<ParticipantEntitie?>  listParticipants;
  final List<UserEntity?>  listContactDirect;
  final List<ChatEntitie?> listChats;
  final String? userId;

  const CreateChatState({
    required this.status,
    required this.errorMessage,
    this.userId,
    this.listContactDirect = const [],
    this.listParticipants = const[],
    this.listUsers = const [],
    this.listChats = const[],
  });

  factory CreateChatState.initial(
    List<UserEntity?>  listUsers, 
    List<UserEntity?>  listContactDirect ,
    List<ChatEntitie?> listChats, 
    String userId) =>
  CreateChatState(status: CreateChatStatus.createDirect, errorMessage: null,
  listUsers:listUsers, 
  listContactDirect: listContactDirect, 
  listChats: listChats, 
  userId: userId);
  
  CreateChatState copyWith({
    CreateChatStatus? status,
    String? errorMessage,
    List<ParticipantEntitie?>? listParticipants,
    List<UserEntity?>? listContactDirect,
    List<UserEntity?>? listUsers,
    }
  ){
    return CreateChatState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      listParticipants: listParticipants ?? this.listParticipants,
      listContactDirect: listContactDirect ?? this.listContactDirect,
      listUsers: listUsers ?? this.listUsers,
    );
  }
}


enum CreateChatStatus{
  loading,
    updated,
      createDirect,
      createChanel,
      createGroup,
    succes,
  failure,
}