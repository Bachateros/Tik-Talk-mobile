import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
class ChatSettingsView extends StatefulWidget {
  const ChatSettingsView({super.key});

  @override
  State<ChatSettingsView> createState() => _ChatSettingsViewState();
}

class _ChatSettingsViewState extends State<ChatSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => context.read<ChatBloc>().add(StatusChangeEvent(status: ChatStatus.update)), 
        child: Text('здесь будет список контактов и настройки')),
    );
  }
}