import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/domain/bloc/chat/chat_bloc.dart';
import 'package:tik_talk/domain/entities/message_entitie.dart';

class MessageForm extends StatefulWidget {
  final String chatId;
  const MessageForm({super.key, required this.chatId});

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

  // Future<void> _pickFile() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     withData: true,
  //   );
  //   if (result != null && result.files.isNotEmpty) {
  //     final file = result.files.first;
  //     debugPrint('Файл выбран: ${file.name}, размер: ${file.size}');
  //     // Здесь можно отправить файл через Bloc (ChatBloc -> SendMessageFile)
  //   }
  // }

  void _sendMessage() {
    final chat = context.read<ChatBloc>().state.chatModel;
    final id = context.read<AuthBloc>().state.userModel.userId;
    final text = _controller.text.trim();
    final date = DateTime.now();
    if (text.isEmpty) return;
    final msg = MessageEntitie(
      idChat: chat!.idChat, 
      idUser: id!, 
      content: text, 
      typeMessage: MessageType.text, 
      createdAt: date);

    context.read<ChatBloc>().add(SendMessageEvent(message: msg));
    _controller.clear();
  }

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Кнопка добавить файл
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: /* _pickFile */ _sendMessage,//TODO: разобраться с сообщениями в которых есть файл
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