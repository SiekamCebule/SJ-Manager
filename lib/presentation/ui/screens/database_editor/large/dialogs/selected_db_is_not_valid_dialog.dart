import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';

class SelectedDbIsNotValidDialog extends StatelessWidget {
  const SelectedDbIsNotValidDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(translate(context).loadingError),
      content: Text(translate(context).invalidDatabaseFolderWarning),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(translate(context).ok),
        )
      ],
    );
  }
}
