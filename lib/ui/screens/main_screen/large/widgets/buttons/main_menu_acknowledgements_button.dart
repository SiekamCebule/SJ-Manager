part of '../../../main_screen.dart';

class MainMenuAcknowledgementsButton extends StatelessWidget {
  const MainMenuAcknowledgementsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Button(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
          Icon(
            Symbols.folded_hands,
            size: UiMainMenuConstants.smallerButtonIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
          Text(
            translate(context).acknowledgements,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
