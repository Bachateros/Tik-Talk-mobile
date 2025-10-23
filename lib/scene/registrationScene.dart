import 'package:flutter/material.dart';

class RegistrationScene extends StatefulWidget {
  const RegistrationScene({super.key});
  
  @override
  State<StatefulWidget> createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationScene>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Registration'),
        ),
        body: const Center(
          child: Text('Пока пусто'),
        ),
      ),
    );
  }
}