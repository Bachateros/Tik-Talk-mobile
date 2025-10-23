import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tik_talk/scene/codeScene.dart';

import 'bloc/AuthProvider.dart';

import 'scene/chatScene.dart';
import 'scene/homeScene.dart';
import 'scene/loginScene.dart';
import 'scene/registrationScene.dart';
import 'scene/userProfilScene.dart';

void main() => runApp(ChangeNotifierProvider(
  create: (_) => AuthProvider()..init(),
  child: const MyApp(),
));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tik-Talk messenger',
      theme: ThemeData(fontFamily: 'JetBrainsMono'),
      routes: {
        '/login': (context) => const LoginScene(),
        '/login/verify':(context)=> const CodeScene(),
        '/register': (context) => const RegistrationScene(),
        '/home': (context) => const HomeScene(),
        '/chatScene': (context) => const ChatnScene(),
        '/profile': (context) => const ProfileScene(),
      },
      initialRoute: '/login',
    );
  }
}

// class FirstScreen extends StatefulWidget{
//   const FirstScreen({super.key});
//   @override
//   State<FirstScreen> createState() => _ScreenState();
// }

// class _ScreenState extends State<FirstScreen>{
//   @override
//   void initState() {
//     super.initState();
//   }
// }
