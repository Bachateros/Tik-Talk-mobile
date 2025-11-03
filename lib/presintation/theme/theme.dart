import 'package:flutter/material.dart';
import 'theme_colors.dart';
import 'theme_text.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    fontFamily: 'JetBrainsMono',
    textTheme: const TextTheme(
      bodyLarge: AppTextStyles.body14,
      bodyMedium: AppTextStyles.container12,
      titleLarge: AppTextStyles.heading20,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'JetBrainsMono',
    textTheme: const TextTheme(
      bodyLarge: AppTextStyles.body14,
      bodyMedium: AppTextStyles.container12,
      titleLarge: AppTextStyles.heading20,
    ),
  );
}
