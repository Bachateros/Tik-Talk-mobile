import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/presintation/screens/chat/widgets/list_messeges.dart';
import 'package:tik_talk/presintation/screens/chat/widgets/message_form.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override 
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessagesEvent());
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ListMesseges(),
          // MessageForm(chatId: chatId!,),
        ]
      ),
    );
  }
}