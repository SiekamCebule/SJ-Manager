part of '../../../main_screen.dart';

class MainMenuDatabaseEditorButton extends StatelessWidget {
  const MainMenuDatabaseEditorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _Button(
      child: Row(
        children: [
          const Gap(UiConstants.horizontalSpaceBetweenMainMenuButtonItems),
          Icon(
            Symbols.database,
            size: UiConstants.mainMenuSmallerButtonIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const Gap(UiConstants.horizontalSpaceBetweenMainMenuButtonItems),
          Text(
            translate(context).databaseEditor,
            style: GoogleFonts.dosis(
              color: Theme.of(context).colorScheme.primary,
              textStyle: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
      onTap: () {
        router.navigateTo(context, '/databaseEditor');
      },
    );
  }
}
