import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent,ProfileState>{
  ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileState(status: ProfileStatus.unknown,errorMessage: null,profile: UserEntity())){
    on<LoadProfileEvent>(_onLoadProfile);
    on<LoadMyUserProfileEvent>(_onLoadMyUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<SwitchSettingProfileEvent>(_onSwitchSettingProfile);
  }

  Future<void>_onLoadMyUserProfile(LoadMyUserProfileEvent event,Emitter emit)async{
    try{
      final userProfile= await repository.getUser(event.userId);
      emit(state.copyWith(profile: userProfile,status: ProfileStatus.me,errorMessage: null));
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
      emit(state.copyWith(profile: userProfile,status: ProfileStatus.succes,errorMessage: null));
    } catch (e){
      print('Ошибка закрузки профиля пользователя ${event.idUser}: $e');
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: 'Ошибка закрузки профиля пользователя ${event.idUser}: $e',
      ));
    }

  }

  Future<void>_onUpdateUserProfile(UpdateUserProfileEvent event,Emitter emit) async {
    // final authlocal = DIContainer().container.get<AuthLocalDataSource>();
    try {
      final resp = await repository.updateUser(bio: event.aboutMe,birthOfDay:event.birthdayDate,avatar: event.avatarUrl, userId: state.profile!.userId);
      if (resp){
        emit(state.copyWith(status: ProfileStatus.updated,errorMessage: null));
      }else {
        emit(state.copyWith(status: ProfileStatus.me, errorMessage: 'Update faild'));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(status: ProfileStatus.me, errorMessage: 'Ошибка обновления пользователя: $e'));
    }
  }

  Future<void>_onSwitchSettingProfile(SwitchSettingProfileEvent event, Emitter emit)async{
    emit(state.copyWith(status: event.status));
  }


}