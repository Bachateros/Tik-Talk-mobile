import 'package:flutter/material.dart';
import 'package:tik_talk/presintation/screens/login/widgets/verify_form.dart';
import 'package:tik_talk/presintation/widgets/background_picture.dart';

class VerifyView extends StatelessWidget {
  const VerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundPicture(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child:SingleChildScrollView(
            child: VerifyForm(),
          ),
      ),
      )
    );
  }
}