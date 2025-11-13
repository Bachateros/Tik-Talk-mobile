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

  static String searchBar(BuildContext context){
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? 'images/dark_theme_serch_bar.png' : 'images/light_them_logo1.png';
  }

  static String noAvatarUser(BuildContext context){
    return 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  }

  static String noAvatarChat(BuildContext context){
    return 'https://wp.logos-download.com/wp-content/uploads/2022/01/ChatCoin_Logo-2048x2048.png';
  }
}