import 'package:flutter/material.dart';

class EventSeriesSetupIdHelpDialog extends StatelessWidget {
  const EventSeriesSetupIdHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Identyfikator'),
      content: const Text(
          'Każdy cykl zawodów posiada swój unikalny identyfikator. Może to być skrót - np. "sjc" dla "Ski Jumping Cup"'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
