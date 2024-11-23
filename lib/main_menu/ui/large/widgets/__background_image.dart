part of '../../main_screen.dart';

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/img/bg/main_menu.jpeg',
      fit: BoxFit.fill,
      color: Colors.black.withOpacity(UiGlobalConstants.backgroundImageTransparency),
      colorBlendMode: BlendMode.dstATop,
    );
  }
}
