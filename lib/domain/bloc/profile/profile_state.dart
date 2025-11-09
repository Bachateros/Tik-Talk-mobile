part of 'profile_bloc.dart';

class ProfileState {
  final ProfileStatus status;
  final UserEntity? profile;
  final List<UserEntity>? contacts;
  final String? errorMessage;

  const ProfileState({
    required this.status,
    this.profile,
    this.contacts,
    this.errorMessage,
  });

  factory ProfileState.initial() => ProfileState(status: ProfileStatus.initial);

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? profile,
    List<UserEntity>? contacts,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      contacts: contacts ?? this.contacts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


enum ProfileStatus { initial, loading, success, failure }
