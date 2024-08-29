import 'package:flutter/material.dart';

class EventSeriesSetupPriorityHelpDialog extends StatelessWidget {
  const EventSeriesSetupPriorityHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Priorytet'),
      content: const Text(''),
      actions: [
        TextButton(
          key: const Key('close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
