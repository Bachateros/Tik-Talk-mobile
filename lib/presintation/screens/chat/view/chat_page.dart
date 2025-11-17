import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/presintation/screens/chat/view/chat_settings_view.dart';
import 'package:tik_talk/presintation/screens/chat/view/chat_view.dart';
import 'package:tik_talk/presintation/screens/chat/widgets/app_bar_chat.dart';
import 'package:tik_talk/presintation/widgets/failed_load_view.dart';
import 'package:tik_talk/presintation/widgets/side_menu.dart';

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
    
    return BlocListener<ChatBloc,ChatState>(
      listenWhen: (previous, current) => previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $errorMessage')),
          );
        }
      },
      child:  BlocBuilder<ChatBloc,ChatState>(
      buildWhen:(previous, current) => current.chatId != null && previous.status != current.status || 
      current.listMesseges.length != previous.listMesseges.length ||
      current.listParticipant.length != previous.listParticipant.length,
      builder: (context, state) => SafeArea(
        child: (){
          if (state.status == ChatStatus.update){
          return Scaffold(
              appBar: AppBarChat(),
              drawer: SideMenu(),
              body:ChatView(),
            );
          } else if(state.status == ChatStatus.setting){
            return Scaffold(
              appBar: AppBarChat(),
              drawer: SideMenu(),
              body:ChatSettingsView(),
            );
          }
          else {
            return Scaffold(
              appBar: AppBarChat(),
              drawer: SideMenu(),
              body:FailedLoadView(),
            );
          } 
          }(),
        )
      )
    );
  
  }
}

