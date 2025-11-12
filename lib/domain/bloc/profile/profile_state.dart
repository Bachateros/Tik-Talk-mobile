part of 'profile_bloc.dart';

class ProfileState {
  final ProfileStatus status;
  final UserEntity? profile;
  final String? errorMessage;

  const ProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
  });

  factory ProfileState.initial() => ProfileState(status: ProfileStatus.initial);

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
      initial, 
      succes, 
        me, 
        edit,
  failure,
  }
