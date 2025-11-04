import 'package:flutter/material.dart';
import 'package:tik_talk/presintation/theme/theme_text.dart';
import 'package:tik_talk/presintation/widgets/background_picture.dart';

class HomeFailedLoadView extends StatelessWidget {
  final String? errorMessage;
  const HomeFailedLoadView({super.key, required this.errorMessage,});

  @override
  Widget build(BuildContext context) {
    return BackgroundPicture(
      showLogo: false,
      child: Center(
        child: errorMessage != null ?
        Text(
          errorMessage!, 
          style: AppTextStyles.button14,
        ) : null
      ),
      );
  }
}