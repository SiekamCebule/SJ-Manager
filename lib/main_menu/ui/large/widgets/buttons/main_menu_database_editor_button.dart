part of '../../../main_screen.dart';

class MainMenuDatabaseEditorButton extends StatelessWidget {
  const MainMenuDatabaseEditorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuOnlyTitleButton(
      titleText: translate(context).databaseEditor,
      iconData: Symbols.edit,
      onTap: () async {
        final gameVariantState = context.read<GameVariantCubit>().state;
        if (gameVariantState is! GameVariantAbleToChoose) {
          throw StateError(
              'Cannot select a game variant because GameVariantCubit hasn\'t been initialized');
        }
        if (!context.mounted) return;
        final gameVariantToEdit = await showSjmDialog(
          barrierDismissible: true,
          context: context,
          child: SelectGameVariantToEditDialog(
            gameVariants: gameVariantState.variants,
          ),
        ) as GameVariant?;
        if (!context.mounted) return;
        if (gameVariantToEdit != null) {
          await context.read<GameVariantCubit>().chooseGameVariant(gameVariantToEdit);
          if (!context.mounted) return;
          router.navigateTo(
            context,
            '/databaseEditor/${gameVariantToEdit.id}',
          );
        }
      },
    );
  }
}
