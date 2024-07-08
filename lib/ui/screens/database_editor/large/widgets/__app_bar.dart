part of '../../database_editor_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Edytor bazy danych'),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Zapisz jako'),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
