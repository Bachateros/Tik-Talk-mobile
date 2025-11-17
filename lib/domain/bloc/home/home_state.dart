part of 'home_bloc.dart';

class HomeState {
  final HomeStatus status;
  final UserEntity? user;
  final List<UserEntity?> users;
  final List<UserEntity?> listContacts;
  final List<ChatWithLastMessageEntitie?> listLastMesseges;
  final String? errorMessage;

  const HomeState({
    required this.status,
    this.listLastMesseges = const [],
    this.errorMessage,
    this.user,
    this.users= const[],  
    this.listContacts = const [],
  });

  factory HomeState.initial() =>
      HomeState(status: HomeStatus.unknown, user: UserEntity());


  List<UserEntity?> get contacts =>listContacts;

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    UserEntity? user,
    List<UserEntity?>? users,
    List<UserEntity?>? listContacts,
    List<ChatWithLastMessageEntitie?>? listLastMesseges,
    String? userId,
  }) => HomeState(
    status: status ?? this.status,
    user: user ?? this.user,
    errorMessage: errorMessage,
    listContacts: listContacts ?? this.listContacts,
    listLastMesseges: listLastMesseges ?? this.listLastMesseges,
    users: users ?? this.users,
  );
}





enum HomeStatus { unknown, loading, success, failure}

