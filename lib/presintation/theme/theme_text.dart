import 'package:flutter/material.dart';
import 'theme_colors.dart';

class AppTextStyles {
  static const _fontFamily = 'JetBrainsMono';

  static const body14 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    color: AppColors.lightText,
  );

  static const button14 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const container12 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const heading20 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const authHeading48 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w700,
  );

  static const verifyHeading36 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
  );

  // Шрифт для чатов (стандартный системный)
  static const chatText = TextStyle(
    fontFamilyFallback: ['Roboto', 'Arial'],
    fontSize: 14,
    color: Colors.black,
  );
}
