import 'package:flutter/material.dart';

class MainMenuBackgroundImage extends StatelessWidget {
  const MainMenuBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/img/bg/main_menu.jpeg',
        fit: BoxFit.fill,
        color: Colors.black.withOpacity(0.1),
        colorBlendMode: BlendMode.dstATop,
      ),
    );
  }
}
