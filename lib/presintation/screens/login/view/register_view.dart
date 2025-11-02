import 'package:flutter/material.dart';
import 'package:tik_talk/presintation/screens/login/widgets/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child:SingleChildScrollView(
          child: RegisterForm(),
        ),
      ),
    );
  }
}