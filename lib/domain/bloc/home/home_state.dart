part of 'home_bloc.dart';

class HomeState {
  final HomeStatus status;
  final HomeEntitie homeModel;
  final String? errorMessage;

  const HomeState({
    required this.status,
    required this.homeModel,
    this.errorMessage
  });

  factory HomeState.initial() =>
      HomeState(status: HomeStatus.unknown, homeModel: HomeEntitie());

  HomeEntitie get model => homeModel;

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    HomeEntitie? homeModel,
  }) => HomeState(
    status: status ?? this.status,
    errorMessage: errorMessage,
    homeModel: homeModel ?? this.homeModel
  );
}


enum HomeStatus { unknown, update, loading, success, failure}

