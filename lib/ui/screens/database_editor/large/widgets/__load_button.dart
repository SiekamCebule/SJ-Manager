part of '../../database_editor_screen.dart';

class _LoadButton extends StatelessWidget {
  const _LoadButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final path = await FilePicker.platform.getDirectoryPath();
        if (!context.mounted || path == null) return;
        final dir = Directory(path);
        if (!directoryIsValidForDatabase(context, dir)) {
          await showDialog(
            context: context,
            builder: (context) => const SelectedDbIsNotValidDialog(),
          );
        } else {
          await context.read<CopiedLocalDbCubit>().loadExternal(context, dir);
          if (!context.mounted) return;
          context.read<SelectedIndexesRepo>().clearSelection();
          context.read<DbFiltersRepo>().clear();
        }
      },
      child: const Text('Wczytaj'),
    );
  }
}
