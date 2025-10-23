import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/AuthProvider.dart';
import 'homeScene.dart';

class CodeScene extends StatefulWidget {
  const CodeScene({super.key});

  @override
  State<CodeScene> createState() => _CodeSceneState();
}

class _CodeSceneState extends State<CodeScene> {
  final _codeController = TextEditingController();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Введите код')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: '6-значный код',
                errorText: _error.isEmpty ? null : _error,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final success = await auth.loginStep2(_codeController.text);
                if (success) {
                  // переходим в HomeScene
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScene()),
                    (route) => false,
                  );
                } else {
                  setState(() => _error = 'Неверный код или ошибка сервера');
                }
              },
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}