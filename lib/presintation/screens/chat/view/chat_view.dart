import 'package:flutter/widgets.dart';
import 'package:tik_talk/presintation/screens/chat/widgets/list_messeges.dart';
import 'package:tik_talk/presintation/screens/chat/widgets/message_form.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Expanded(
            child: ListMesseges(),
          ),
          MessageForm(),
        ]
      );
  }
}