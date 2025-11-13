import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/profile/profile_bloc.dart';
import 'package:tik_talk/presintation/screens/profile/widgets/profile_view_form.dart';
import 'package:tik_talk/presintation/screens/splash/splash_screen.dart';
import 'package:tik_talk/presintation/screens/profile/widgets/app_bar_profile.dart';
import 'package:tik_talk/presintation/widgets/failed_load_view.dart';
import 'package:tik_talk/presintation/widgets/side_menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override 
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return BlocListener<ProfileBloc,ProfileState>(
      listenWhen: (previous, current) => previous.errorMessage != current.errorMessage && current.status == ProfileStatus.updated,
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $errorMessage')),
          );
        }

      },
      child:  BlocBuilder<ProfileBloc,ProfileState>(
      buildWhen:(previous, current) => previous.status != current.status ,
      builder: (context, state) => SafeArea(
        child: (){
          if (state.status == ProfileStatus.me || state.status == ProfileStatus.succes){
          return Scaffold(
              appBar: AppBarProfile(),
              drawer: SideMenu(),
              body:ProfileViewForm(),
            );
          } else if(state.status == ProfileStatus.edit){
            return Scaffold(
              appBar: AppBarProfile(),
              drawer: SideMenu(),
              body:ProfileEditForm(),
            );
          }else if(state.status == ProfileStatus.failure){
            final errorMes =context.read<ProfileBloc>().state.errorMessage;
            return FailedLoadView(errorMessage: errorMes,);
          }else {
            return SplashScreen();
          } 
          }(),
        )
      )
    );
  
  }
}

