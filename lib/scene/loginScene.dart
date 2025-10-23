import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/AuthProvider.dart';
import 'codeScene.dart'; // экран для ввода кода

class LoginScene extends StatefulWidget {
  const LoginScene({super.key});

  @override
  State<LoginScene> createState() => _LoginSceneState();
}

class _LoginSceneState extends State<LoginScene> {
  final _controller = TextEditingController();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Номер телефона',
                errorText: _error.isEmpty ? null : _error,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final res = await auth.loginStep1(_controller.text);
                if (res == 'OK') {
                  // переходим на ввод кода
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CodeScene()),
                  );
                } else {
                  setState(() => _error = res ?? 'Ошибка запроса');
                }
              },
              child: const Text('Далее'),
            ),
          ],
        ),
      ),
    );
  }
}
