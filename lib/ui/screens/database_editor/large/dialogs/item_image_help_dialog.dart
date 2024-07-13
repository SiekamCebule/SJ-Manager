import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';

class ItemImageHelpDialog extends StatelessWidget {
  const ItemImageHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(translate(context).images),
      content: Text(
        translate(context).itemImageHelpContent,
      ),
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
