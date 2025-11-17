import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_colors.dart';

class ListMesseges extends StatelessWidget {
  const ListMesseges({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.listMesseges.length != current.listMesseges.length,
      builder: (context, state) {
        var messages = context.read<ChatBloc>().state.listMesseges;

        if (messages.isEmpty) {
          return const Center(child: Text('Сообщений пока нет'));
        }

        final sorted = [...messages]..sort((a, b) {
          return b!.createdAt.compareTo(a!.createdAt); 
        });

        return ListView.builder(
          reverse: true,                  
          padding: const EdgeInsets.all(8),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final msg = sorted[index]!;
            final userId = context.read<HomeBloc>().state.user!.userId;
            final isMine = msg.idUser == userId;

            return Align(
              alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  left: isMine ? 60 : 8,
                  right: isMine ? 8 : 60,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isMine ? AppColors.primary : AppColors.chatConteiner,
                  borderRadius: BorderRadius.only(
                    topRight: isMine ? const Radius.circular(0) : const Radius.circular(16),
                    topLeft: isMine ? const Radius.circular(16) : const Radius.circular(0),
                    bottomLeft: const Radius.circular(16),
                    bottomRight: const Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: isMine ?const EdgeInsets.only(bottom: 12, left: 25) :const EdgeInsets.only(bottom: 12, right: 25),
                      child: Text(
                        msg.content,
                        style: TextStyle(
                          color: isMine ? AppColors.lightText : Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: isMine ? null : 0 ,
                      left: isMine ? 0 : null,
                      child: Text(
                        _formatTime(msg.createdAt),
                        style: TextStyle(
                          color: isMine ? const Color.fromARGB(120, 0, 0, 0).withValues() : const Color.fromARGB(120, 255, 255, 255),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}


String _formatTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
  
  if (messageDate == today) {
    // Сегодня - показываем только время
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } else {
    // Не сегодня - показываем дату
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}';
  }
}