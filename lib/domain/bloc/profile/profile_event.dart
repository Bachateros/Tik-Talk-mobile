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

class SwitchSettingProfileEvent extends ProfileEvent{
  final ProfileStatus status;
  SwitchSettingProfileEvent({required this.status});
}

class UpdateUserProfileEvent extends ProfileEvent {
  final String? avatarUrl;
  final String? aboutMe;
  final DateTime? birthdayDate;

  UpdateUserProfileEvent({
    this.avatarUrl,
    this.aboutMe,
    this.birthdayDate,
  });
}



