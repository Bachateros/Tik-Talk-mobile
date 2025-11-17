import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/last_message_chat_entitie.dart';
import 'package:tik_talk/presintation/screens/splash/splash_home_screan.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous.status != current.status ||
       previous.listLastMesseges.length != current.listLastMesseges.length,
      builder: (context, state) {
        final lastMessages = context.read<HomeBloc>().state.listLastMesseges;
        final users = state.users;
        final location = GoRouter.of(context).routerDelegate.currentConfiguration.last.matchedLocation;
        if (location != '/home'){
          return SplashHomeScreen();
        } 
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: lastMessages.length,
          itemBuilder: (context, index) {
            final chat = lastMessages[index]?.chat;
            final lastMessage = lastMessages.firstWhere(
              (m) => m!.chat.idChat == chat?.idChat,
              orElse: () => ChatWithLastMessageEntitie(chat: chat!, lastMessage: null),
            );

            return Card(
              color: AppColors.chatConteiner,
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade300,
                  radius: 18,
                  backgroundImage:  NetworkImage(chat?.typeChat == ChatType.direct ? (){
                      final user = users.firstWhere((u)=> (u!.userId == lastMessages[index]?.contactId));
                      if (user?.avatarUrl == '' || user?.avatarUrl ==null )
                      {
                        return ThemeAssets.noAvatarChat(context);
                      } else {
                        return user!.avatarUrl!;
                      }
                  }(): chat?.avatarUrl == null || chat?.avatarUrl== '' 
                                ? ThemeAssets.noAvatarChat(context)
                                : chat!.avatarUrl!,
                  ),
                ),
                
                title: Text(
                     chat?.typeChat == ChatType.direct ? (){
                      final user = users.firstWhere((u)=> (u!.userId == lastMessages[index]?.contactId));
                      return '${user!.surname} ${user.name}';
                     }() 
                     : chat?.nameChat == null ? 
                     (chat?.typeChat == ChatType.channel ? 'Канал' : 'Группа') 
                     : chat!.nameChat,
                  style: const TextStyle(color: AppColors.menuGrey, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  lastMessage!.lastMessage?.content ?? 'Нет сообщений',
                  style: const TextStyle(color: AppColors.darkText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                onTap: () {
                  context.push('/home/chat/${chat!.idChat}');
                  
                }
              ),
            );
          },
        );
      },
    );
  }
}
