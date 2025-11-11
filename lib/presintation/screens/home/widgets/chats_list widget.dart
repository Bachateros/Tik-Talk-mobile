import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/home_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  final withoutURI = 'https://wp.logos-download.com/wp-content/uploads/2022/01/ChatCoin_Logo-2048x2048.png';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final chats = state.homeModel.chats;
        final lastMessages = state.homeModel.lastMessages;

        if (chats.isEmpty) {
          return const Center(child: Text('Нет доступных чатов'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            final lastMessage = lastMessages.firstWhere(
              (m) => m!.chat.idChat == chat!.idChat,
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
                  child: Image.network(chat?.avatarUrl ?? withoutURI)
                ),
                title: Text(
                     chat?.typeChat == ChatType.direct ? _getDirectChatUserName(chat,context)
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




String _getDirectChatUserName(ChatEntitie? chat, BuildContext context) {
  if (chat == null) return 'Пользователь';
  
  final homeState = context.read<HomeBloc>().state;
  final currentUserId = homeState.userId;
  
  // Находим участников этого чата
  final chatParticipants = homeState.listContacts
      .where((participant) => participant?.chatId == chat.idChat)
      .whereType<ParticipantEntitie>()
      .toList();
  
  // Находим собеседника (не текущего пользователя)
  final otherParticipant = chatParticipants
      .firstWhere(
        (participant) => participant.userId != currentUserId,
      );
  
  // Находим пользователя по ID
  final otherUser = homeState.users
      .whereType<UserEntity>()
      .firstWhere(
        (user) => user.userId == otherParticipant.userId,
        orElse: () => UserEntity(
          userId: '',
          name: 'Неизвестный',
          surname: 'пользователь',
        ),
      );
  
  return '${otherUser.name} ${otherUser.surname}'.trim();
}