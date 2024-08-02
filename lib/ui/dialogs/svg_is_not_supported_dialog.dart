import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';

class SvgIsNotSupportedDialog extends StatelessWidget {
  const SvgIsNotSupportedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ach ten SVG...'),
      content: const Text(
        'Niestety, format zdjęcia SVG nie jest wspierany dla zdjęć w tym miejscu.\n Nie wiesz o co chodzi? Prawdopodobnie jedno z twoich zdjęć ma rozszerzenie .svg!',
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
