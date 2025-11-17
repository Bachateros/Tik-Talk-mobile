import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/create_chat_bloc/create_chat_bloc.dart';
import 'package:tik_talk/presintation/screens/chat_create/view/create_chat_view.dart';
import 'package:tik_talk/presintation/screens/chat_create/widget/app_bar_create.dart';
import 'package:tik_talk/presintation/screens/splash/splash_home_screan.dart';
import 'package:tik_talk/presintation/widgets/failed_load_view.dart';
import 'package:tik_talk/presintation/widgets/side_menu.dart';

class CreateChatPage extends StatefulWidget {
  const CreateChatPage({super.key});

  @override
  State<CreateChatPage> createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateChatBloc,CreateChatState>(
      listenWhen: (previous, current) => previous.errorMessage != current.errorMessage || previous.status != current.status,
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $errorMessage')),
          );
        }
      },
      child:  BlocBuilder<CreateChatBloc,CreateChatState>(
      buildWhen:(previous, current) => previous.status != current.status ,
      builder: (context, state) => SafeArea(
        child: (){
          if (state.status == CreateChatStatus.failure){
            return Scaffold(
              appBar: AppBarCreate(),
              drawer: SideMenu(),
              body:FailedLoadView(errorMessage: context.read<CreateChatBloc>().state.errorMessage,),
            );
          }else if(state.status == CreateChatStatus.succes){
            return SplashHomeScreen();
          }else if(state.status == CreateChatStatus.loading){
            return SplashHomeScreen();
          }
          else {
            return Scaffold(
              appBar: AppBarCreate(),
              drawer: SideMenu(),
              body: CreateChatView(),
            ); 
          } 
          }(),
        )
      )
    );
  
  }
}