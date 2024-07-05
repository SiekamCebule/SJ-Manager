part of '../../../main_screen.dart';

class MainMenuLoadSimulationButton extends StatelessWidget {
  const MainMenuLoadSimulationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Button(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(UiConstants.horizontalSpaceBetweenMainMenuButtonItems),
          Icon(
            Symbols.open_in_new,
            size: UiConstants.mainMenuSmallerButtonIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const Gap(UiConstants.horizontalSpaceBetweenMainMenuButtonItems),
          Text(
            translate(context).loadSimulation,
            style: GoogleFonts.dosis(
              color: Theme.of(context).colorScheme.primary,
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
