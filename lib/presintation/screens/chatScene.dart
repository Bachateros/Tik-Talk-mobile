import 'package:flutter/material.dart';


class ChatnScene extends StatefulWidget {
  const ChatnScene({super.key});
  
  @override
  State<StatefulWidget> createState() => _ChatnSceneState();
}

class _ChatnSceneState extends State<ChatnScene> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chat Scene'),
        ),
        body: const Center(
          child: Text('Чат пока пуст 🗨️'),
        ),
      ),
    );
  }
}