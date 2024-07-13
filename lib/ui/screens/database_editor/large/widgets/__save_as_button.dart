part of '../../database_editor_screen.dart';

class _SaveAsButton extends StatelessWidget {
  const _SaveAsButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final dir = await FilePicker.platform.getDirectoryPath();
        if (!context.mounted || dir == null) return;
        await context.read<CopiedLocalDbCubit>().saveAs(context, Directory(dir));
      },
      child: Text(translate(context).saveAs),
    );
  }
}
