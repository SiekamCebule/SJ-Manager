import 'package:flutter/material.dart';

class ItemImageHelpDialog extends StatelessWidget {
  const ItemImageHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zdjęcia'),
      content: const Text(
        'Na podstawie wprowadzonych danych, SJM automatycznie znajduje zdjęcie zawodników, zawodniczek i skoczni.\nDla skoczków i skoczkiń: <kraj>_<imię>_<nazwisko>.png\nDla skoczni: <lokalizacja>_<punkt hs>.<dowolne rozszerzenie>',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
