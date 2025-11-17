part of 'profile_bloc.dart';

class ProfileState {
  final ProfileStatus status;
  final UserEntity? profile;
  final String? errorMessage;

  const ProfileState({
    required this.status,
    this.profile,
    required this.errorMessage,
  });

  factory ProfileState.initial() => ProfileState(status: ProfileStatus.unknown, errorMessage: null);

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


enum ProfileStatus { 
  unknown,
      loading, 
      succes,
      updated, 
        me, 
        edit,
  failure,
  }
