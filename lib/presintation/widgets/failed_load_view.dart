import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tik_talk/presintation/theme/theme_assets.dart';
import 'package:tik_talk/presintation/theme/theme_text.dart';

class FailedLoadView extends StatelessWidget {
  final String? errorMessage;
  const FailedLoadView({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ThemeAssets.background(context)),
          fit: BoxFit.cover,
        ),
      ),
      child:Text(
          errorMessage ?? '',
          style: AppTextStyles.container12,
        ),
      ),
    );
  }
}