
import 'package:flutter/material.dart';
import 'package:tik_talk/presintation/widgets/custom_app_bar.dart';

class SplashHomeScreen extends StatelessWidget {
  const SplashHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(child: CircularProgressIndicator()));
  }
}
