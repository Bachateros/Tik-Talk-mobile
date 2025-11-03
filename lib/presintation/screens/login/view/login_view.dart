import 'package:flutter/material.dart';
import 'package:tik_talk/presintation/screens/login/widgets/login_form.dart';
import 'package:tik_talk/presintation/widgets/background_picture.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BackgroundPicture(
      topPadding: 180,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child:SingleChildScrollView(
            child: LoginForm(),
            
          ),
      ),
      )
    
    );
  }
}
