import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/presintation/screens/splash/splash_home_screan.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.listLastMesseges.length != current.listLastMesseges.length,
      builder: (context, state) {
        final lastMessages = state.listLastMesseges;
        final users = state.users;

        final location = GoRouter.of(context)
            .routerDelegate
            .currentConfiguration
            .last
            .matchedLocation;

        if (location != '/home') {
          return SplashHomeScreen();
        }

        final sortedList = [...lastMessages]..sort((a, b) {
          final lmA = a!.lastMessage;
          final lmB = b!.lastMessage;

          if (lmA == null && lmB == null) {
            return b.chat.lastActivityAt!.compareTo(a.chat.lastActivityAt!);
          }

          if (lmA == null) return -1;
          if (lmB == null) return 1;

          return b.lastMessage!.createdAt.compareTo(a.lastMessage!.createdAt);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: sortedList.length,
          itemBuilder: (context, index) {
            final item = sortedList[index]!;
            final chat = item.chat;
            final lastMessage = item.lastMessage;

            final user = users.firstWhere(
              (u) => u?.userId == item.contactId,
              orElse: () => UserEntity(),
            );

            final avatarUrl = chat.typeChat == ChatType.direct
                ? (user?.avatarUrl?.isNotEmpty ?? false)
                    ? user!.avatarUrl!
                    : ThemeAssets.noAvatarChat(context)
                : (chat.avatarUrl?.isNotEmpty ?? false)
                    ? chat.avatarUrl!
                    : ThemeAssets.noAvatarChat(context);

            final title = chat.typeChat == ChatType.direct
                ? (user != null
                    ? '${user.surname} ${user.name}'
                    : 'Неизвестный пользователь')
                : (chat.nameChat.isNotEmpty)
                    ? chat.nameChat
                    : (chat.typeChat == ChatType.channel ? 'Канал' : 'Группа');

            return Card(
              color: AppColors.chatConteiner,
              elevation: 3,
              margin:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade300,
                  radius: 18,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                      color: AppColors.menuGrey,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  lastMessage?.content ?? 'Нет сообщений',
                  style: const TextStyle(color: AppColors.darkText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  context.push('/home/chat/${chat.idChat}');
                },
              ),
            );
          },
        );
      },
    );
  }
}
