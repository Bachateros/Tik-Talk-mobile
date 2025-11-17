import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/profile/profile_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';

class AppBarProfile extends StatefulWidget implements PreferredSizeWidget {
  const AppBarProfile({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarProfile> createState() => _AppBarProfileState();
}

class _AppBarProfileState extends State<AppBarProfile> {

  @override
  Widget build(BuildContext context) {
    // final chat = context.read<ChatBloc>().state.chatModel;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ThemeAssets.searchBar(context)),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topLeft,
        ),
      ),
      child: AppBar(
        leading: Builder(
          builder: (context) {
            if (context.read<ProfileBloc>().state.status == ProfileStatus.edit){
              return IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => context.read<ProfileBloc>().add(SwitchSettingProfileEvent(status: ProfileStatus.me))
              );
            } else {
              return IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => context.pop(), 
              );
            }
          },
              //       
          //  

        ),
        centerTitle: true,
        title: Text('Profile'),
        actions: [
          BlocBuilder<ProfileBloc,ProfileState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder:(context, state) => state.status == ProfileStatus.me ? IconButton( 
                icon: const Icon(Icons.more_vert),
                color: Colors.white,
                onPressed: () => context.read<ProfileBloc>().add(SwitchSettingProfileEvent(status: ProfileStatus.edit),
                ),
              ): const SizedBox.shrink(),
            ),
        ],
        backgroundColor: Colors.transparent,
      )
    );
  }
}