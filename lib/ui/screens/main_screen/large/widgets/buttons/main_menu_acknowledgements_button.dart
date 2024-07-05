part of '../../../main_screen.dart';

class MainMenuAcknowledgementsButton extends StatelessWidget {
  const MainMenuAcknowledgementsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Button(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(UiConstants.horizontalSpaceBetweenMainMenuButtonItems),
          Icon(
            Symbols.folded_hands,
            size: UiConstants.mainMenuSmallerButtonIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const Gap(UiConstants.horizontalSpaceBetweenMainMenuButtonItems),
          Text(
            translate(context).acknowledgements,
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
