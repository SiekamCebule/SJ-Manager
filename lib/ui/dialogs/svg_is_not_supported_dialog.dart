import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';

class SvgIsNotSupportedDialog extends StatelessWidget {
  const SvgIsNotSupportedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ach ten SVG...'),
      content: const Text(
        'Format zdjęcia SVG nie jest tu jeszcze wspierany. Pracujemy nad tym!',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(translate(context).ok),
        ),
      ],
    );
  }
}
