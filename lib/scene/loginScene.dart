import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tik_talk/bloc/AuthProvider.dart';

class LoginScene extends StatefulWidget {
  const LoginScene({super.key});

  @override
  State<LoginScene> createState() => _LoginSceneState();
}

class _LoginSceneState extends State<LoginScene> {
  // Контроллеры полей для удобного получения текста
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // показывает индикатор при выполнении запроса

  // Важно освобождать контроллеры в dispose
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Метод, который выполняет логин, используя AuthProvider
  Future<void> _doLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Получаем AuthProvider через context.read (не подписываемся на изменения)
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Простейшая валидация
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final success = await auth.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Переходим на домашний экран и заменяем стек
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка входа — проверьте email/пароль')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Можно использовать context.watch<AuthProvider>() в UI, если нужно отображать данные пользователя.
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 18),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _doLogin,
                    child: const Text('Войти'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Регистрация'),
            ),
          ],
        ),
      ),
    );
  }
}