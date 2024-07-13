part of '../../database_editor_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    const gapBetweenActions = Gap(UiDatabaseEditorConstants.gapBetweenAppBarActions);
    return AppBar(
      title: Text(translate(context).databaseEditor),
      actions: const [
        _SaveAsButton(),
        gapBetweenActions,
        _LoadButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
