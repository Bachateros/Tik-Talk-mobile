import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent,ProfileState>{
  ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileState(status: ProfileStatus.unknown,profile: UserEntity())){
    on<LoadProfileEvent>(_onLoadProfile);
    on<LoadMyUserProfileEvent>(_onLoadMyUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<SwitchSettingProfileEvent>(_onSwitchSettingProfile);
  }

  Future<void>_onLoadMyUserProfile(LoadMyUserProfileEvent event,Emitter emit)async{
    try{
      final userProfile= await repository.getUser(event.userId);
      emit(state.copyWith(profile: userProfile,status: ProfileStatus.me));
    } catch (e){
      print('Ошибка закрузки профиля пользователя (текущий пользователя): $e');
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: 'Ошибка закрузки профиля пользователя (текущий пользователя): $e',
      ));
    }
  }

  Future<void>_onLoadProfile(LoadProfileEvent event,Emitter emit )async {
    try{
      
      final userProfile= await repository.getUser(event.idUser);
      emit(state.copyWith(profile: userProfile,status: ProfileStatus.succes));
    } catch (e){
      print('Ошибка закрузки профиля пользователя ${event.idUser}: $e');
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: 'Ошибка закрузки профиля пользователя ${event.idUser}: $e',
      ));
    }

  }

  Future<void>_onUpdateUserProfile(UpdateUserProfileEvent event,Emitter emit) async {
    try {
      if (await repository.updateUser(bio: event.aboutMe,birthOfDay:event.birthdayDate,avatar: event.avatarUrl, userId: state.profile!.userId)){
        emit(state.copyWith(status: ProfileStatus.updated));
        emit(state.copyWith(status: ProfileStatus.me));
      }else {
        emit(state.copyWith(status: ProfileStatus.me, errorMessage: 'Update faild'));
      }

    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }

  Future<void>_onSwitchSettingProfile(SwitchSettingProfileEvent event, Emitter emit)async{
    emit(state.copyWith(status: event.status));
  }


}