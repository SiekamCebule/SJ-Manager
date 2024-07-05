part of '../../main_screen.dart';

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/img/bg/main_menu.jpeg',
        fit: BoxFit.fill,
        color: Colors.black.withOpacity(UiConstants.backgroundImageTransparency),
        colorBlendMode: BlendMode.dstATop,
      ),
    );
  }
}
