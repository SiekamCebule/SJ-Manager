part of '../../database_editor_screen.dart';

class _SaveAsButton extends StatelessWidget {
  const _SaveAsButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      /*onPressed: () async {
        final dirPath = await FilePicker.platform.getDirectoryPath();
        if (!context.mounted || dirPath == null) return;
        await context.read<LocalDatabaseCopyCubit>().saveAs(context, Directory(dirPath));
        if (!context.mounted) return;
        await showDialog(
          context: context,
          builder: (context) => DatabaseSuccessfullySavedDialog(
            dirPath: dirPath,
          ),
        );
      },*/
      onPressed: null, // TODO: DO THAT
      child: Text(translate(context).saveAs),
    );
  }
}
