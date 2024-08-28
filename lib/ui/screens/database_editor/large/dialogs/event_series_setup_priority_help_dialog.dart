import 'package:flutter/material.dart';

class EventSeriesSetupPriorityHelpDialog extends StatelessWidget {
  const EventSeriesSetupPriorityHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Priorytet'),
      content: const Text(
          'Im niższa cyfra, tym zawody są ważniejsze. Najważniejszy cykl w symulacji powinien mieć numer 1, tak jak imprezy mistrzowskie. Zaplecze jako 2, zaplecze zaplecza 3, i tak dalej...'),
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
