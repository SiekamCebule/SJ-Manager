part of '../../../main_screen.dart';

class MainMenuDatabaseEditorButton extends StatelessWidget {
  const MainMenuDatabaseEditorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuOnlyTitleButton(
      titleText: translate(context).databaseEditor,
      iconData: Symbols.edit,
      onTap: () async {
        final gameVariants = context.read<ItemsRepo<GameVariant>>();
        if (!context.mounted) return;
        final gameVariantToEdit = await showSjmDialog(
          barrierDismissible: true,
          context: context,
          child: SelectGameVariantToEditDialog(
            gameVariants: gameVariants.last.toList(),
          ),
        ) as GameVariant?;
        if (!context.mounted) return;
        if (gameVariantToEdit != null) {
          router.navigateTo(
            context,
            '/databaseEditor/${gameVariantToEdit.id}',
          );
        }
      },
    );
  }
}
