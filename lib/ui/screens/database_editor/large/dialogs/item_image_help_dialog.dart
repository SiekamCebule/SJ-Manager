import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';

class ItemImageHelpDialog extends StatelessWidget {
  const ItemImageHelpDialog({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    DialogTheme(
        contentTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w300,
            ));
    return AlertDialog(
      title: Text(translate(context).images),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(translate(context).ok),
        ),
      ],
    );
  }
}
