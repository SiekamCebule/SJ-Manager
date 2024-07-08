import 'package:flutter/material.dart';

class DatabaseEditorUnsavedChangesDialog extends StatelessWidget {
  const DatabaseEditorUnsavedChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zapisać zmiany?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop('yes'),
          child: const Text('Tak'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop('no'),
          child: const Text('Nie'),
        ),
      ],
    );
  }
}
