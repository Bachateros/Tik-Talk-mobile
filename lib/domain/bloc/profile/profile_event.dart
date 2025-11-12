part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class LoadMyUserProfileEvent extends ProfileEvent {
  String userId;
  LoadMyUserProfileEvent({required this.userId});
}

class LoadProfileEvent extends ProfileEvent {
  final String idUser;
  LoadProfileEvent({required this.idUser});
}

class SwitchSettingProfileEvent{
  final ProfileStatus status;
  SwitchSettingProfileEvent({required this.status});
}

class UpdateUserProfileEvent extends ProfileEvent {
  final String name;
  final String surname;
  final String? avatarUrl;
  final String? aboutMe;
  final DateTime? birthdayDate;

  UpdateUserProfileEvent({
    required this.name,
    required this.surname,
    this.avatarUrl,
    this.aboutMe,
    this.birthdayDate,
  });
}



