import 'package:flutter/material.dart';
import 'package:tik_talk/presintation/theme/theme_background.dart';

class BackgroundPicture extends StatelessWidget {
  final Widget child;
  final bool showLogo;
  final double topPadding;
  
  const BackgroundPicture({super.key, required this.child, this.showLogo = true, this.topPadding = 150, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ThemeAssets.background(context)),
            fit: BoxFit.cover,
            alignment: Alignment.centerLeft,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24, topPadding, 24, 24),
                  child: child,
                ),
              ),
              if (showLogo)
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      ThemeAssets.logo(context),
                      height: 120,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
