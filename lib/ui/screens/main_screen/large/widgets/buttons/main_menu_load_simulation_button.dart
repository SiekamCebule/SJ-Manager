part of '../../../main_screen.dart';

class MainMenuLoadSimulationButton extends StatelessWidget {
  const MainMenuLoadSimulationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuOnlyTitleButton(
      titleText: translate(context).loadSimulation,
      iconData: Symbols.open_in_new,
      onTap: () {},
    );
  }
}
