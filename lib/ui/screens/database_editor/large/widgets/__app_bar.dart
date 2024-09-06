part of '../../database_editor_screen.dart';

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  State<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<_AppBar> {
  final _appBarActionRowKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const gapBetweenActions = Gap(UiDatabaseEditorConstants.gapBetweenAppBarActions);
    return AppBar(
      title: Text(translate(context).databaseEditor),
      actions: [
        Row(
          key: _appBarActionRowKey,
          mainAxisSize: MainAxisSize.min,
          children: const [
            _SaveAsButton(),
            gapBetweenActions,
            _LoadButton(),
          ],
        ),
      ],
    );
  }
}
