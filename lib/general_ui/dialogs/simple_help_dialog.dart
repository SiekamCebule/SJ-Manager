import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';

class SimpleHelpDialog extends StatelessWidget {
  const SimpleHelpDialog({
    super.key,
    required this.titleText,
    required this.contentText,
  });

  final String titleText;
  final String contentText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Text(contentText),
      actions: [
        TextButton(
          key: const Key('close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            translate(context).ok,
          ),
        ),
      ],
    );
  }
}

Future<void> showSimpleHelpDialog({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  await showSjmDialog(
    barrierDismissible: true,
    context: context,
    child: SimpleHelpDialog(titleText: title, contentText: content),
  );
}
