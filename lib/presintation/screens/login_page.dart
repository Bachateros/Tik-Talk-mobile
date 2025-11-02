import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final tgController = TextEditingController();
//   final passController = TextEditingController();
//   bool hidePassword = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const Text(
//                   'Вход' /*style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)*/,
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: tgController,
//                   decoration: const InputDecoration(
//                     labelText: 'Telegram Username',
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: passController,
//                   obscureText: hidePassword,
//                   decoration: InputDecoration(
//                     labelText: 'Пароль',
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         hidePassword ? Icons.visibility : Icons.visibility_off,
//                       ),
//                       onPressed:
//                           () => setState(() => hidePassword = !hidePassword),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     context.read<AuthBloc>().add(
//                       LoginEvent(tgController.text, passController.text),
//                     );
//                   },
//                   child: const Text('Войти'),
//                 ),
//                 const SizedBox(height: 10),
//                 TextButton(
//                   onPressed: () {
//                     context.push('/sign_up');
//                   },
//                   child: const Text('Регистрация'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
