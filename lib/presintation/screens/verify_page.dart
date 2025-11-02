import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';

class VerifyPage extends StatefulWidget {
  final int userId;
  const VerifyPage({super.key, required this.userId});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final code = List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var c in code) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Введите код подтверждения'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                return Container(
                  width: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: code[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.isNotEmpty && i < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: const InputDecoration(counterText: ''),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final input = code.map((c) => c.text).join();
                context.read<AuthBloc>().add(VerifyEvent(widget.userId, input));
              },
              child: const Text('Подтвердить'),
            ),
          ],
        ),
      ),
    );
  }
}
