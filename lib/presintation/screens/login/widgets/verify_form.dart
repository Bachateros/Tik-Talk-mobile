import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/auth/auth_bloc.dart';
import 'package:tik_talk/presintation/theme/theme_text.dart';

class VerifyForm extends StatefulWidget {
  const VerifyForm({super.key});

  @override
  State<VerifyForm> createState() => _VerifyFormState();
}

class _VerifyFormState extends State<VerifyForm> {
  final code = List.generate(6, (_) => TextEditingController());
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var c in code) {
      c.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
          key: _formkey,
          child: Column(
            children: [
            const Text('Введите код подтверждения',style:AppTextStyles.verifyHeading36),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                return Container(
                  width: 35,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white,fontSize: 12),
                    controller: code[i],
                    autovalidateMode: AutovalidateMode.onUserInteraction, // Автовалидация
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "";
                      }
                      if (!RegExp(r'^[0-9]$').hasMatch(value)) {
                        return "";
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.isNotEmpty && i < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                      if (value.isEmpty && i > 0) {
                        FocusScope.of(context).previousFocus();
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
                // Проверяем что все 6 полей заполнены цифрами
                bool isValid = true;
                for (int i = 0; i < code.length; i++) {
                  final value = code[i].text;
                  if (value.isEmpty || !RegExp(r'^[0-9]$').hasMatch(value)) {
                    isValid = false;
                    break;
                  }
                }
                
                if (isValid) {
                  final input = code.map((c) => c.text).join();
                  context.read<AuthBloc>().add(VerifyEvent(input));
                } else {
                  // Показываем ошибку если нужно
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Заполните все 6 цифр кода'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Подтвердить'),
            ),
          ],
        ),
    );
  }
}