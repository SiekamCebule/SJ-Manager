part of '../../../main_screen.dart';

class MainMenuAcknowledgementsButton extends StatelessWidget {
  const MainMenuAcknowledgementsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuOnlyTitleButton(
      titleText: translate(context).acknowledgements,
      iconData: Symbols.folded_hands,
      onTap: () {},
    );
  }
}
