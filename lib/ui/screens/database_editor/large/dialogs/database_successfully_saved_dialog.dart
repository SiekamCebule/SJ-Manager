import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';

class DatabaseSuccessfullySavedDialog extends StatelessWidget {
  const DatabaseSuccessfullySavedDialog({
    super.key,
    required this.dirPath,
  });

  final String dirPath;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zapisano bazę danych'),
      content: Text(
          'Kopia aktualnej bazy danych została zapisana w folderze $dirPath'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(translate(context).ok),
        ),
      ],
    );
  }
}
