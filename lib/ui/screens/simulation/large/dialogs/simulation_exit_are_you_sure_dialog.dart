import 'package:flutter/material.dart';

class SimulationExitAreYouSureDialog extends StatelessWidget {
  const SimulationExitAreYouSureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zapisać zmiany?'),
      content: const Text(
        'Czy przed wyjściem chcesz zapisać zmiany w symulacji?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Nie'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Tak'),
        ),
      ],
    );
  }
}
