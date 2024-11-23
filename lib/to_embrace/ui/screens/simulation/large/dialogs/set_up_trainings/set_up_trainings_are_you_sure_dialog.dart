import 'package:flutter/material.dart';

class SetUpTrainingsAreYouSureDialog extends StatelessWidget {
  const SetUpTrainingsAreYouSureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zapisać trening?'),
      content: const Text(
        'Czy na pewno chcesz zatwierdzić obecny plan treningowy? Możesz zmienić go w dowolnym momencie.',
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
