import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/presintation/screens/chat/widgets/channel_form.dart';
import 'package:tik_talk/presintation/screens/chat/widgets/list_messeges.dart';
import 'package:tik_talk/presintation/screens/chat/widgets/message_form.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final type = context.read<ChatBloc>().state.chatModel!.typeChat;
    final userId = context.read<HomeBloc>().state.user!.userId;
    final myRole = context.read<ChatBloc>().state.listParticipant.firstWhere((p)=>p!.userId == userId)!.role;
    return Column(
        children: [
          Expanded(
            child: ListMesseges(),
          ),
          type == ChatType.channel ? myRole == RoleParticipant.admin || myRole == RoleParticipant.owner ? MessageForm(): ChannelForm() :MessageForm(),
        ]
      );
  }
}