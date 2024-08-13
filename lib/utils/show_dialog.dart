import 'package:flutter/material.dart';

Future<T?> showSjmDialog<T>({
  required BuildContext context,
  required Widget child,
}) async {
  return await showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1200,
          ),
          child: child,
        ),
      );
    },
  );
}
