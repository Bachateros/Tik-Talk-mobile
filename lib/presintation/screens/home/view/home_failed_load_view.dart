import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tik_talk/presintation/theme/theme_text.dart';

class HomeFailedLoadView extends StatelessWidget {
  final String? errorMessage;
  const HomeFailedLoadView({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        errorMessage ?? '',
        style: AppTextStyles.container12,
      ),
    );
  }
}