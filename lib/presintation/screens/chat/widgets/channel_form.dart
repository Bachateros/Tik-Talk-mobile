import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';

class ChannelForm extends StatelessWidget {
  const ChannelForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: const Border(
          top: BorderSide(color: Colors.grey, width: 0.4),
        ),
      ),
      child: ElevatedButton(
        onPressed: ()=> context.read<ChatBloc>().add(EntryToChatEvent()), 
        child: Center(
          child: Icon(Icons.input_rounded,color: AppColors.accent,),
        )
        ), 
    );
  }
}