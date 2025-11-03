import 'package:flutter/material.dart';

class ThemeAssets {
  static String background(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? 'images/dark_theme.png' : 'images/light_theme.png';
  }

  static String logo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? 'images/dark_theme_logo1.png' : 'images/light_them_logo1.png';
  }
}