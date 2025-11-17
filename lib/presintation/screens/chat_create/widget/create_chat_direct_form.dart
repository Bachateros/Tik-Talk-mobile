import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/create_chat_bloc/create_chat_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';

class CreateChatDirectForm extends StatelessWidget {
  const CreateChatDirectForm({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<CreateChatBloc>().state;
    final myId = state.userId;

    // список всех контактов из HomeBloc
    final allUsers = state.listUsers;

    // список всех direct-чатов
    final myDirectChats = state.listChats.where(
      (c) => c?.typeChat == ChatType.direct
    );

    // формируем список "с кем директ уже есть"
    final existingDirectUserIds = <String>{};
    for (final chat in myDirectChats) {
      for (final part in state.listParticipants) {
        if (part?.chatId == chat?.idChat) {
          existingDirectUserIds.add(part!.userId);
        }
      }
    }

    // фильтруем список — убрать меня + убрать тех, с кем уже есть direct
    final filteredUsers = allUsers.where((u) {
      if (u == null) return false;
      if (u.userId == myId) return false;
      if (existingDirectUserIds.contains(u.userId)) return false;
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        const SizedBox(height: 8),

        // кнопки
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text("Создать группу"),
              onPressed: () {
                context.read<CreateChatBloc>().add(
                  SwitchCreateChatEvent(status: CreateChatStatus.createGroup),
                );
              },
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text("Создать канал"),
              onPressed: () {
                context.read<CreateChatBloc>().add(
                  SwitchCreateChatEvent(status: CreateChatStatus.createChanel)
                );
              },
            ),
          ),
        ),
        const Divider(color: Colors.white24, thickness: 1),
        const SizedBox(height: 16),
        const Text("Создать чат для двоих", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 12),

        Expanded(
          child: ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final u = filteredUsers[index]!;
              return Card(
              color: AppColors.chatConteiner,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade300,
                  backgroundImage: NetworkImage(
                    u.avatarUrl != '' ? u.avatarUrl! : ThemeAssets.noAvatarUser(context),
                  ),
                ),
                title: Text(
                  '${u.name} ${u.surname}',
                  style: const TextStyle(
                    color: AppColors.menuGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  final chat = ChatEntitie(
                    idChat: "",
                    nameChat: "",
                    descriptionChat: null,
                    typeChat: ChatType.direct,
                    avatarUrl: null,
                    isPrivate: false,
                    createdAt: DateTime.now(),
                    updatedAt: null,
                    createdBy: myId,
                    maxMembers: 2,
                    lastActivityAt: null,
                  );

                  final participants = [
                    ParticipantEntitie(
                      id: null,
                      createdAt: null,
                      updatedAt: null,
                      deletedAt: null,
                      chatId: "",
                      userId: u.userId,
                      role: RoleParticipant.member,
                      joinedAt: DateTime.now(),
                      isMuted: false,
                      notificationsEnabled: true,
                    ),
                  ];

                  context.read<CreateChatBloc>().add(
                    CreateNewChatEvent(chat: chat, listParticipant: participants),
                  );
                  
                  context.read<HomeBloc>().add(UpdateEvent());
                  context.pop();

                },
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
