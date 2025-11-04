import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/home_entitie.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final chats = state.homeModel.chats;
        final lastMessages = state.homeModel.lastMesseges;

        if (chats.isEmpty) {
          return const Center(child: Text('Нет доступных чатов'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            final lastMessage = lastMessages.firstWhere(
              (m) => m.chat.idChat == chat.idChat,
              orElse: () => ChatWithLastMessegeEntitie(chat: chat, lastMessege: null),
            );

            return Card(
              color: AppColors.chatConteiner,
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade300,
                  child: Text(chat.nameChat[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Text(
                  chat.nameChat,
                  style: const TextStyle(color: AppColors.menuGrey, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  lastMessage.lastMessege?.content ?? 'Нет сообщений',
                  style: const TextStyle(color: AppColors.darkText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => context.push('/home/chat/${chat.idChat}'),
              ),
            );
          },
        );
      },
    );
  }
}


