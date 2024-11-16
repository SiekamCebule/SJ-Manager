import 'package:flutter/material.dart';

Future<T?> showSjmDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = false,
}) async {
  return await showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1000,
          ),
          child: child,
        ),
      );
    },
  );
}
