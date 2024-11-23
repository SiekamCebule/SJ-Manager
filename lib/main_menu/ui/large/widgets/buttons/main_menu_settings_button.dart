part of '../../../main_screen.dart';

class MainMenuSettingsButton extends StatelessWidget {
  const MainMenuSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuOnlyTitleButton(
      titleText: translate(context).settings,
      iconData: Symbols.settings,
      onTap: () {
        router.navigateTo(context, '/settings');
      },
    );
  }
}
