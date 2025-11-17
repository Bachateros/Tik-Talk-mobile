import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';

class ChatSettingsView extends StatelessWidget {
  const ChatSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final chat = state.chatModel;
        final participants = state.listParticipant;
        if (chat == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final myId = context.read<HomeBloc>().state.user!.userId;

        /// Определяем текущего пользователя в чате
        final me = participants.firstWhere(
          (p) => p!.userId == myId,
          orElse: () => ParticipantEntitie(
            id: '',
            chatId: chat.idChat,
            userId: myId,
            role: RoleParticipant.member,
            isMuted: false,
            notificationsEnabled: true,
          ),
        );
        UserEntity? contact;
        final role = me!.role;
        if (chat.typeChat == ChatType.direct){
          final contactId = participants.firstWhere(
            (p)=> p!.userId != myId,
          )!.userId;
          contact = context.read<HomeBloc>().state.users.firstWhere((u)=> u!.userId == contactId);
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [

            // --------------------------
            // 1. Аватарка
            // --------------------------
            Center(
              child: GestureDetector(
                onTap: () {
                  if (chat.typeChat == ChatType.direct) return;
                  if (chat.typeChat == ChatType.group) {
                    // Все могут менять
                    _changeAvatar(context);
                  } else if (chat.typeChat == ChatType.channel) {
                    // Только admin / owner
                    if (role == RoleParticipant.admin ||
                        role == RoleParticipant.owner) {
                      _changeAvatar(context);
                    }
                  }
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: chat.typeChat == ChatType.direct ?  
                    contact?.avatarUrl != null || contact?.avatarUrl != ''
                      ? NetworkImage(contact!.avatarUrl!)
                      : NetworkImage(ThemeAssets.noAvatarUser(context))
                  :chat.avatarUrl != null
                      ? NetworkImage(chat.avatarUrl!)
                      : null,
                  child: chat.avatarUrl == null && chat.typeChat != ChatType.direct
                      ? const Icon(Icons.group, size: 32)
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --------------------------
            // 2. Название чата
            // --------------------------
            Center(
              child: Text(
                chat.nameChat,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),
            const Divider(),

            // --------------------------
            // 4. Верхняя строка кнопок
            // --------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // MUTE / UNMUTE
                IconButton(
                  icon: Icon(me.isMuted ? Icons.volume_off : Icons.volume_up),
                  onPressed: () {
                    context.read<ChatBloc>().add(
                      ChatUpdateEvent(), // далее внутри репы обновишь участника
                    );
                  },
                ),

                // ПРОФИЛЬ пользователя (для DIRECT)
                if (chat.typeChat == ChatType.direct)
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      context.push('/home/profile/${chat.createdBy}');
                    },
                  ),

                // Удалить / Покинуть чат
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.primary),
                  onPressed: () {
                    if (chat.typeChat!=ChatType.direct && role != RoleParticipant.owner){
                      _leaveChat(context);
                    } else{
                      _deleteChat(context);
                    }
                  },
                ),

                // Только admin/owner → изменить приватность / настройки
                if (role == RoleParticipant.admin || role == RoleParticipant.owner)
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      _changePrivacy(context);
                    },
                  ),
              ],
            ),

            const Divider(height: 32),

            // --------------------------
            // 5. Список участников для GROUP/CHANNEL
            // --------------------------
            if (chat.typeChat != ChatType.direct)
              _buildParticipantsList(
                context: context,
                participants: participants,
                myRole: role,
                chatId: chat.idChat,
              ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------
  // Изменение аватара чата
  // ---------------------------------------------------------
  void _changeAvatar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Изменение аватара чата...")),
    );
  }

  // ---------------------------------------------------------
  // Выйти из чата / очистить данные
  // ---------------------------------------------------------
  void _leaveChat(BuildContext context) {
    context.read<ChatBloc>().add(LeaveFromChat());
    context.pop();
  }

  void _deleteChat(BuildContext context){
    context.read<ChatBloc>().add(DeleteChatEvent());
    context.pop();
  }

  // ---------------------------------------------------------
  // Изменить приватность
  // ---------------------------------------------------------
  void _changePrivacy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Изменение приватности чата...")),
    );
  }

  // ---------------------------------------------------------
  // Список участников (для group/channel)
  // ---------------------------------------------------------
  Widget _buildParticipantsList({
    required BuildContext context,
    required List<ParticipantEntitie?> participants,
    required RoleParticipant myRole,
    required String chatId,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Участники:", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),

        ...participants.map((p) => _participantTile(
              context: context,
              participant: p,
              myRole: myRole,
              chatId: chatId,
            )),
      ],
    );
  }

  // ---------------------------------------------------------
  // Одна строка участника
  // ---------------------------------------------------------
  Widget _participantTile({
    required BuildContext context,
    required ParticipantEntitie? participant,
    required RoleParticipant myRole,
    required String chatId,
  }) {
    final isMe = participant?.userId ==
        context.read<HomeBloc>().state.user!.userId;
    final users = context.read<HomeBloc>().state.users;
    final contact = users.firstWhere((u)=> u!.userId==participant!.userId);
    final avatar = contact?.avatarUrl != null && contact?.avatarUrl != '' ? contact!.avatarUrl : ThemeAssets.noAvatarUser(context);
    return BlocBuilder<ChatBloc,ChatState>(
      buildWhen: (previous, current) => previous.listParticipant.length != current.listParticipant.length,
      builder:(context, state) =>  Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade900,
        ),
        child: TextButton(

          onPressed: () => context.push('/home/profile/:${participant!.userId}'),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatar!),
                ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  "${contact!.name} ${contact.surname}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              // Только ADMIN/OWNER могут управлять другими
              if (!isMe &&
                  (myRole == RoleParticipant.admin ||
                      myRole == RoleParticipant.owner))
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "mute",
                      child: Text(
                        participant!.isMuted ? "Включить звук" : "Заглушить",
                      ),
                    ),
                    PopupMenuItem(
                      value: "kick",
                      child: Text(
                        "Исключить",
                        style: TextStyle(color: Colors.red.shade300),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == "kick") {
                      context.read<ChatBloc>().add(KickParticipantEvent(part: participant!));
                    } else if (value == "mute") {
                      context.read<ChatBloc>().add(ChatUpdateEvent());
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
