part of '../../../main_screen.dart';

class MainMenuDatabaseEditorButton extends StatelessWidget {
  const MainMenuDatabaseEditorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuOnlyTitleButton(
      titleText: translate(context).databaseEditor,
      iconData: Symbols.database,
      onTap: () {
        router.navigateTo(context, '/databaseEditor');
      },
    );
  }
}
