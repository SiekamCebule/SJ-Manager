import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sj_manager/general_ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/general_ui/reusable_widgets/help_icon_button.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    this.controller,
    required this.onChange,
    this.formatters,
    required this.labelText,
    this.focusNode,
    this.enabled = true,
    this.onHelpButtonTap,
  });

  final bool enabled;
  final VoidCallback onChange;
  final TextEditingController? controller;
  final List<TextInputFormatter>? formatters;
  final String labelText;
  final FocusNode? focusNode;
  final VoidCallback? onHelpButtonTap;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(UiFieldWidgetsConstants.borderRadius),
      borderSide: BorderSide(
        width: UiFieldWidgetsConstants.borderSideWidth,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
    final showHelpButton = onHelpButtonTap != null;

    final textField = TextField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        label: Text(labelText),
        enabledBorder: border,
        border: border,
      ),
      inputFormatters: formatters,
      onSubmitted: (value) => onChange(),
      onTapOutside: (event) => onChange(),
      focusNode: focusNode,
    );

    return showHelpButton
        ? Row(
            children: [
              Expanded(child: textField),
              HelpIconButton(onPressed: onHelpButtonTap!),
            ],
          )
        : textField;
  }
}
