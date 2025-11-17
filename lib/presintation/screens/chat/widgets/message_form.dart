import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/domain/bloc/home/home_bloc.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';

class MessageForm extends StatefulWidget {
  const MessageForm({super.key});

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final chat = context.read<ChatBloc>().state.chatModel;
    final id = context.read<HomeBloc>().state.user!.userId;
    final text = _controller.text.trim();
    final clientId = context.read<HomeBloc>().state.user!.clientId;
    final date = DateTime.now();
    if (text.isEmpty) return;
    final msg = MessageEntitie(    
      idChat: chat!.idChat, 
      idUser: id,
      replyToId: null,
      content: text, 
      clientId: clientId,
      typeMessage: MessageType.text, 
      createdAt: date,
      isDeleted: false
      );

    context.read<ChatBloc>().add(SendMessageEvent(message: msg));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context){ 
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: const Border(
          top: BorderSide(color: Colors.grey, width: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _sendMessage,
          ),

          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 150, 
              ),
              child: Scrollbar(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: null, 
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Введите сообщение...',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Кнопка отправить
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}