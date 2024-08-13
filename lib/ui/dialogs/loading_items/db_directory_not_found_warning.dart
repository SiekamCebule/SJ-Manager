import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/utils/fonts.dart';

class DbDirectoryNotFoundWarning extends StatelessWidget {
  const DbDirectoryNotFoundWarning({
    super.key,
    required this.title,
    required this.newDirectoryPath,
    required this.targetDirectory,
  });

  final String title;
  final String newDirectoryPath;
  final String targetDirectory;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Flexible(child: Text(title)),
          const Gap(15),
          Icon(
            Symbols.warning,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 32,
          ),
        ],
      ),
      content: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: 'Stworzyliśmy dla ciebie pusty folder ',
              style: dialogLightFont(context)),
          TextSpan(text: newDirectoryPath, style: dialogBoldFont(context)),
          TextSpan(text: ' w folderze ', style: dialogLightFont(context)),
          TextSpan(text: targetDirectory, style: dialogBoldFont(context)),
          TextSpan(text: '.', style: dialogLightFont(context)),
        ]),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        )
      ],
    );
  }
}
