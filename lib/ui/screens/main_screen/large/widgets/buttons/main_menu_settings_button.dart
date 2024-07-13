part of '../../../main_screen.dart';

class MainMenuSettingsButton extends StatelessWidget {
  const MainMenuSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Button(
      child: Row(
        children: [
          const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
          Icon(
            Symbols.settings,
            size: UiMainMenuConstants.smallerButtonIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const Gap(UiMainMenuConstants.horizontalSpaceBetweenButtonItems),
          Text(
            translate(context).settings,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
      onTap: () {
        router.navigateTo(context, '/settings');
      },
    );
  }
}
