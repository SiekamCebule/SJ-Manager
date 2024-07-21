import 'package:flutter/material.dart';
import 'package:sj_manager/utils/close_app.dart';

class LoadingItemsFailedDialog extends StatelessWidget {
  const LoadingItemsFailedDialog({
    super.key,
    required this.titleText,
    required this.filePath,
    required this.error,
  });

  final String titleText;
  final String filePath;
  final Object error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Text(
          'Sprawdź poprawność danych w pliku $filePath i spróbuj ponownie.\nTreść błędu: $error'),
      actions: [
        TextButton(
          onPressed: () async {
            await closeApp();
          },
          child: const Text('Zamknij aplikację'),
        ),
      ],
    );
  }
}
