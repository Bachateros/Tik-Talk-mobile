import 'package:flutter/material.dart';
import 'package:tik_talk/presintation/widgets/background_picture_auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundPicture(
      child: Padding(
        padding: EdgeInsetsGeometry.only(top: 230),
        child: Center(
          child: CircularProgressIndicator()
        ),
      )
    );
  }
}
