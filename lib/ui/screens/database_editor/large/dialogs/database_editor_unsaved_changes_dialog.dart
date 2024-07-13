import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';

class DatabaseEditorUnsavedChangesDialog extends StatelessWidget {
  const DatabaseEditorUnsavedChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(translate(context).saveChangesQuestion),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop('yes'),
          child: Text(translate(context).yes),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop('no'),
          child: Text(translate(context).no),
        ),
      ],
    );
  }
}
