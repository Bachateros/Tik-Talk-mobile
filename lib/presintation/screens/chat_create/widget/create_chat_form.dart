import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/create_chat_bloc/create_chat_bloc.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';

class CreateChatForm extends StatefulWidget {
  final bool isGroup;
  const CreateChatForm({super.key, required this.isGroup});

  @override
  State<CreateChatForm> createState() => _CreateChatFormState();
}

class _CreateChatFormState extends State<CreateChatForm> {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  final selectedUsers = <String>{};

  @override
  Widget build(BuildContext context) {
    final state = context.read<CreateChatBloc>().state;
    final myId = state.userId;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: nameCtrl,
          style: TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: "Название чата"),
        ),
        TextField(
          controller: descCtrl,
          style: TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: "Описание"),
        ),

        const SizedBox(height: 20),
        if (widget.isGroup)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Добавить участников"),
              const SizedBox(height: 8),

              ...state.listUsers.map((u) {
                if (u == null || u.userId == myId) return const SizedBox.shrink();

                final selected = selectedUsers.contains(u.userId);

                return CheckboxListTile(
                  value: selected,
                  title: Text(u.name),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedUsers.add(u.userId);
                      } else {
                        selectedUsers.remove(u.userId);
                      }
                    });
                  },
                );
              }),
            ],
          ),

        const SizedBox(height: 20),
        ElevatedButton(
          child: const Text("Создать"),
          onPressed: () {
            final chat = ChatEntitie(
              idChat: "",
              nameChat: nameCtrl.text,
              descriptionChat: descCtrl.text,
              typeChat: widget.isGroup ? ChatType.group : ChatType.channel,
              avatarUrl: null,
              isPrivate: false,
              createdAt: DateTime.now(),
              updatedAt: null,
              createdBy: myId,
              maxMembers: null,
              lastActivityAt: null,
            );
            if(!widget.isGroup) {
              _channalChatCreate(context, chat);
            } else{
              final List<ParticipantEntitie?> participants = [];
              for (final uid in selectedUsers) {
                participants.add(
                  ParticipantEntitie(
                    id: null,
                    createdAt: null,
                    updatedAt: null,
                    deletedAt: null,
                    chatId: "",
                    userId: uid,
                    role: RoleParticipant.member,
                    joinedAt: DateTime.now(),
                    isMuted: false,
                    notificationsEnabled: true,
                  ),
                );
              }
              _groupChatCreate(context, chat, participants);
            }
          },
          
        )
      ],
    );
  }
}

void _groupChatCreate(BuildContext context,ChatEntitie chat, List<ParticipantEntitie?> listParticipants){
  
  context.read<CreateChatBloc>().add( CreateNewChatEvent(chat: chat, listParticipant: listParticipants), );
  context.pop();
}

void _channalChatCreate(BuildContext context, ChatEntitie chat){
  List<ParticipantEntitie?> listParticipants = [];
  context.read<CreateChatBloc>().add( CreateNewChatEvent(chat: chat, listParticipant: listParticipants), );
  context.pop();
}