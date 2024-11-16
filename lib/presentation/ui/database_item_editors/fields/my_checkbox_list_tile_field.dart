import 'package:flutter/material.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/help_icon_button.dart';

class MyCheckboxListTileField extends StatelessWidget {
  const MyCheckboxListTileField({
    super.key,
    required this.title,
    required this.value,
    this.enabled = true,
    this.tristate = false,
    required this.onChange,
    this.customShape,
    this.onHelpButtonTap,
  });

  final Widget title;
  final bool? value;
  final bool enabled;
  final bool tristate;
  final Function(bool? value) onChange;
  final ShapeBorder? customShape;
  final VoidCallback? onHelpButtonTap;

  @override
  Widget build(BuildContext context) {
    final tile = CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: title,
      value: value,
      enabled: enabled,
      tristate: tristate,
      onChanged: onChange,
      shape: customShape ??
          RoundedRectangleBorder(
            side: BorderSide(
              width: UiFieldWidgetsConstants.borderSideWidth,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            borderRadius: const BorderRadius.all(UiFieldWidgetsConstants.borderRadius),
          ),
    );
    return onHelpButtonTap != null
        ? Row(
            children: [
              Expanded(child: tile),
              HelpIconButton(
                onPressed: onHelpButtonTap!,
              ),
            ],
          )
        : tile;
  }
}
