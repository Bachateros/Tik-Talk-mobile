import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/presintation/theme/theme_background.dart';

class SideMenu extends StatelessWidget{
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer( 
      backgroundColor: Colors.black87,
      child: ListView(
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
              context.push('/settings');
            },
          ),
        ],
      ),

    );
   }
  
}