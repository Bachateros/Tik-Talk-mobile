part of 'home_bloc.dart';

class HomeState {
  final HomeStatus status;
  final HomeEntitie homeModel;
  final String? userId;
  final List<UserEntity?> users;
  final List<ParticipantEntitie?> listContacts;
  final String? errorMessage;

  const HomeState({
    required this.status,
    required this.homeModel,
    this.userId,
    this.users= const[],  
    this.listContacts = const [],
    this.errorMessage
  });

  factory HomeState.initial() =>
      HomeState(status: HomeStatus.unknown, homeModel: HomeEntitie());

  HomeEntitie get model => homeModel;

  List<UserEntity?> get contacts {
  return users.where((user) {
    if (user == null) return false;
    
    return listContacts.any((participant) => 
        participant?.userId == user.userId.toString() && participant?.userId != userId);
    }).toList();
  }

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    List<UserEntity?>? users,
    List<ParticipantEntitie?>? listContacts,
    HomeEntitie? homeModel,
    String? userId,
  }) => HomeState(
    status: status ?? this.status,
    errorMessage: errorMessage,
    homeModel: homeModel ?? this.homeModel,
    listContacts: listContacts ?? this.listContacts,
    userId: userId ?? this.userId,
    users: users ?? this.users,
  );
}





enum HomeStatus { unknown, loading, success, failure}

