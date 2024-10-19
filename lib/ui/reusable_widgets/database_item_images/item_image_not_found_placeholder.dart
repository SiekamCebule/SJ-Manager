import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/utils/show_dialog.dart';

class ItemImageNotFoundPlaceholder extends StatelessWidget {
  const ItemImageNotFoundPlaceholder({
    super.key,
    required this.width,
    required this.height,
    required this.helpDialog,
  });

  final double? width;
  final double? height;
  final Widget helpDialog;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Placeholder(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Center(
                child: Text(
              translate(context).imageNotFound,
              textAlign: TextAlign.center,
            )),
          ),
          Align(
            alignment: Alignment.topRight,
            child: HelpIconButton(
              onPressed: () async {
                await showSjmDialog(
                  barrierDismissible: true,
                  context: context,
                  child: helpDialog,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
