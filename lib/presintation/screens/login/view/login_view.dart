import 'package:flutter/material.dart';
import 'package:tik_talk/presintation/screens/login/widgets/login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child:SingleChildScrollView(
          child: LoginForm()
        ),
      ),
    );
  }
}
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: Text(
  //           "Вход в аккаунт",
  //           style: Theme.of(
  //             context,
  //           ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
  //         ),
  //       ),
  //       Expanded(child: LoginForm()),
  //     ],
  //   );
  // }