import 'package:flutter/material.dart';

class SjmDialogOkPopButton extends StatelessWidget {
  const SjmDialogOkPopButton({
    super.key,
    this.enabled = true,
    this.customOnPressed,
  });

  final bool enabled;
  final VoidCallback? customOnPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enabled
          ? (customOnPressed ??
              () {
                Navigator.of(context).pop();
              })
          : null,
      child: const Text('Ok'),
    );
  }
}
