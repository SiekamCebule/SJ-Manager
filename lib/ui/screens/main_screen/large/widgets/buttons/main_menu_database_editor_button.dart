part of '../../../main_screen.dart';

class MainMenuDatabaseEditorButton extends StatelessWidget {
  const MainMenuDatabaseEditorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuOnlyTitleButton(
      titleText: translate(context).databaseEditor,
      iconData: Symbols.edit,
      onTap: () async {
        final gameVariants = constructDefaultGameVariants(
          context: context,
        ); // TODO: Do it once and keep in some repo or something like that
        final gameVariantToEdit = await showSjmDialog(
          context: context,
          child: SelectGameVariantToEditDialog(
            gameVariants: gameVariants,
          ),
        ) as GameVariant?;
        if (!context.mounted) return;
        print('game variant to edit: $gameVariantToEdit');
        if (gameVariantToEdit != null) {
          router.navigateTo(context, '/databaseEditor');
        }
      },
    );
  }
}
