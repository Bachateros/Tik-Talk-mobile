import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_background.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';
import 'package:tik_talk/presintation/widgets/contacts_list_view.dart';

class SideMenu extends StatelessWidget{
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Drawer( 
      backgroundColor: Colors.black87,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: ListViewSideMenu(),),
              Container(
                margin: EdgeInsets.only(bottom: 110),
                child: SizedBox(
                height: 270,
                child: ContactsListView(),
              ),),
              
              UserCard(),
            ]
          ),
        ),

    );
   }
  
}

class ListViewSideMenu extends StatelessWidget {
  const ListViewSideMenu({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.only(left: 10),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    ThemeAssets.logo(context),
                    width: 79,
                    ),
                    const Text('Tik-Talk', style: TextStyle(color: Colors.white, fontSize: 30)),
                ],
              ),
            ),
            ListTile(            
              title: Row(spacing: 10 ,children: [Icon(Icons.home, size: 25), Text('Моя Страница', style: TextStyle(color: Colors.white),)]),
              onTap: () {
                context.push('/home/profile/me');
              },
            ),
            ListTile(
              title: Row(spacing: 10 ,children: [Icon(Icons.chat, size: 25), Text('Создать Чат', style: TextStyle(color: Colors.white),)]),
              onTap: () {
                context.push('/home/create_chat');
              },
            ),
            ListTile(
              title: Row(spacing: 10 ,children: [Icon(Icons.settings, size: 25), Text('Настройки', style: TextStyle(color: Colors.white),)]),
              onTap: () {
                context.push('/home/settings');
              },
            ),
          ]
    );
  }
}


class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Достаём пользователя из AuthBloc
    final me = context.read<AuthBloc>().state.userModel;
    return  Container(
              color: Colors.grey.shade900,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blueGrey,
                    backgroundImage: NetworkImage(
                      me.profile?.avatarUrl ?? 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      me.tgUsername!,
                      style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: AppColors.primary),
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    }
                  )
  
            ],
          )
        );
  }
}
