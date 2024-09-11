import 'package:flutter/material.dart';

class SjmDialogOkButton extends StatelessWidget {
  const SjmDialogOkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Ok'),
    );
  }
}
