import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';

class ListMesseges extends StatelessWidget {
  const ListMesseges({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc,ChatState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final messages = state.listMesseges;
        if (state.errorMessage!=null){
          return Center(child: 
          TextButton(
            child: Text(state.errorMessage!),
            onPressed: () {
              context.read<ChatBloc>().add(LoadChatEvent(chatId: state.chatModel!.idChat));
              context.pop();
            }
            ),
          );
        }
        if (messages.isEmpty) {
          return Center(child: Text('Сообщений пока нет'));
        }
        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(8),
          itemCount: messages.length,
          itemBuilder: (context,index){
            final msg = messages[index];
            final isMine = msg!.idUser == context.read<HomeBloc>().state.user!.userId;
            return Align(
              alignment: isMine ? Alignment.centerRight: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  left: isMine ? 60 : 8,   // отступ от противоположной стороны
                  right: isMine ? 8 : 60,  // и наоборот
                ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isMine
                        ? AppColors.primary
                        : AppColors.chatConteiner,
                    borderRadius: isMine ? 
                    BorderRadius.only(
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16) ,
                      bottomRight: Radius.circular(16) ,
                      ) : 
                    BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),),
                  ),
                  child: Text(
                    msg.content,
                    style:  TextStyle(color: isMine ? AppColors.lightText: Colors.white),
                  ),
              ),

            );
          }
        );
      }
    );
  }
}