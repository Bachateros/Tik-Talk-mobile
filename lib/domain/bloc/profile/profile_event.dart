part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class LoadCurrentUserProfile extends ProfileEvent {}

class LoadUserProfile extends ProfileEvent {
  final String userId;
  LoadUserProfile(this.userId);
}

class UpdateUserProfile extends ProfileEvent {
  final String name;
  final String surname;
  final String? avatarUrl;
  final String? aboutMe;
  final DateTime? birthdayDate;

  UpdateUserProfile({
    required this.name,
    required this.surname,
    this.avatarUrl,
    this.aboutMe,
    this.birthdayDate,
  });
}

class LoadUserContacts extends ProfileEvent {}

class UpdateAvatarEvent extends ProfileEvent {
  final String avatarUrl;
  UpdateAvatarEvent(this.avatarUrl);
}
