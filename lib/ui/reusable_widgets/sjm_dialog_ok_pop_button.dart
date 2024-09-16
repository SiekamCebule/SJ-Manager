import 'package:flutter/material.dart';

class SjmDialogOkPopButton extends StatelessWidget {
  const SjmDialogOkPopButton({
    super.key,
    this.enabled = true,
  });

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enabled
          ? () {
              Navigator.of(context).pop();
            }
          : null,
      child: const Text('Ok'),
    );
  }
}
