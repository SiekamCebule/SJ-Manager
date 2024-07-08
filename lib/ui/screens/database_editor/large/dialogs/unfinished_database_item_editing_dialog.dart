import 'package:flutter/material.dart';

class UnfinishedDatabaseItemEditingDialog extends StatelessWidget {
  const UnfinishedDatabaseItemEditingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nieskończona edycja'),
      content: const Text(
        'Edytowana rzecz ma jeszcze niewypełnione pola. Musisz ustalić wszystkie parametry.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
