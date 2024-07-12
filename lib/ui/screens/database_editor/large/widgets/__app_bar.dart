part of '../../database_editor_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Edytor bazy danych'),
      actions: const [
        _SaveAsButton(),
        Gap(30),
        _LoadButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
