import 'package:flutter/material.dart';

class SelectedDbIsNotValidDialog extends StatelessWidget {
  const SelectedDbIsNotValidDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Błąd wczytywania'),
      content: const Text('Wybrany folder nie zawiera poprawnej bazy danych'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        )
      ],
    );
  }
}
