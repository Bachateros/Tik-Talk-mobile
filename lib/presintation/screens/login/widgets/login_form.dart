import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_text.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hidePassword = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          children: [
            const Text(
              'Вход' , 
              style: AppTextStyles.authHeading48,
              textAlign: TextAlign.left,

              
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _loginController,
              style: TextStyle(color: Colors.white), 
              autovalidateMode: AutovalidateMode.onUserInteraction, // Автовалидация
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Это поле должно быть заполнено";
                  }
                  return null;
                },
              decoration: const InputDecoration(
                labelText: 'Telegram Username',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              style: TextStyle(color: Colors.white), 
              autovalidateMode: AutovalidateMode.onUserInteraction, // Автовалидация
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Это поле должно быть заполнено";
                  }
                  return null;
                },
              obscureText: _hidePassword,
              decoration: InputDecoration(
                labelText: 'Пароль',
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed:
                      () => setState(() => _hidePassword = !_hidePassword),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style:ButtonStyle(),
              onPressed: () {
                if (_formKey.currentState!.validate()){
                  context.read<AuthBloc>().add(LoginEvent(_loginController.text,_passwordController.text));
                }
              },
              child: const Text('Войти',),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(RegisterPressedEvent());
              },
              child: const Text('Регистрация'),
            ),
          ],
      ),
    );
  }
}


//  Column(
//         children: [
//           TextFormField(
//             controller: _loginController,
//             validator: (value) {
//               if (value == null || value == '') {
//                 return "Это поле должно быть заполнено";
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             controller: _passwordController,
//             validator: (value) {
//               if (value == null || value == '') {
//                 return "Это поле должно быть заполнено";
//               }
//               return null;
//             },
//           ),

//           ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 // DO SMTH
//               }
//             },
//             child: Text("Войти"),
//           ),
//         ],