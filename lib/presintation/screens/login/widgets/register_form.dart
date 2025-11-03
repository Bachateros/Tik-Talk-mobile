import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_text.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final name = TextEditingController();
  final surname = TextEditingController();
  final tg = TextEditingController();
  final pass1 = TextEditingController();
  final pass2 = TextEditingController();

  bool hide1 = true;
  bool hide2 = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    surname.dispose();
    tg.dispose();
    pass1.dispose();
    pass2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Регистрация',
            style: AppTextStyles.verifyHeading36,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: surname,
            style: TextStyle(color: Colors.white), 
            decoration: const InputDecoration(labelText: 'Фамилия'),
          ),
          TextFormField(
            controller: name,
            style: TextStyle(color: Colors.white), 
            decoration: const InputDecoration(labelText: 'Имя'),
          ),
          TextFormField(
            controller: tg,
            style: TextStyle(color: Colors.white), 
            decoration: const InputDecoration(
              labelText: 'Telegram Username',
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: pass1,
            style: TextStyle(color: Colors.white), 
            obscureText: hide1,
            decoration: InputDecoration(
              labelText: 'Пароль',
              suffixIcon: IconButton(
                icon: Icon(
                  hide1 ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() => hide1 = !hide1),
              ),
            ),
          ),
          TextFormField(
            controller: pass2,
            obscureText: hide2,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Повтор пароля',
              suffixIcon: IconButton(
                icon: Icon(
                  hide2 ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() => hide2 = !hide2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (pass1.text == pass2.text) {
                context.read<AuthBloc>().add(
                  RegisterEvent(
                    name.text,
                    surname.text,
                    tg.text,
                    pass1.text,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Пароли не совпадают')),
                );
              }
            },
            child: const Text('Зарегистрироваться'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.read<AuthBloc>().add(AppStarted()),
            child: const Text('Уже есть аккаунт? Войти'),
          ),
        ],
     
        ),
        
      );
  }
}

