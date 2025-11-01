import 'package:flutter/material.dart';

class ProfileScene extends StatefulWidget {
  const ProfileScene({super.key});
  
  @override
  State<StatefulWidget> createState() => _ProfileSceneState();
}

class _ProfileSceneState extends State<ProfileScene>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Scene'),
        ),
        body: const Center(
          child: Text('Пусто'),
        ),
      ),
    );
  }
}