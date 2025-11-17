import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/presintation/screens/home/widgets/chats_list_widget.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc,HomeState>(
      buildWhen: (previous, current) => 
        previous.listLastMesseges.length != current.listLastMesseges.length,
      builder:(context, state) =>  ChatList()
      );
  }
}