import 'package:flutter/material.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';

class MyCheckboxListTileField extends StatelessWidget {
  const MyCheckboxListTileField({
    super.key,
    required this.title,
    required this.value,
    this.enabled = true,
    this.tristate = false,
    required this.onChange,
    this.customShape,
  });

  final Widget title;
  final bool? value;
  final bool enabled;
  final bool tristate;
  final Function(bool? value) onChange;
  final ShapeBorder? customShape;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
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
  }
}
