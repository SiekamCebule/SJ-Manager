import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/help_icon_button.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.textFormFieldKey,
    required this.controller,
    required this.onChange,
    this.formatters,
    required this.labelText,
    this.focusNode,
    this.enabled = true,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.errorMaxLines,
    this.onHelpButtonTap,
    this.trailing,
    this.leading,
  });

  final Key? textFormFieldKey;
  final bool enabled;
  final VoidCallback onChange;
  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;
  final String labelText;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final int? errorMaxLines;
  final VoidCallback? onHelpButtonTap;
  final Widget? trailing;
  final Widget? leading;

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

    final textField = TextFormField(
      key: textFormFieldKey,
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        label: Text(labelText),
        enabledBorder: border,
        border: border,
        errorMaxLines: errorMaxLines,
        prefixIcon: leading,
        suffixIcon: trailing,
      ),
      inputFormatters: formatters,
      onEditingComplete: () => onChange(),
      onTapOutside: (event) => onChange(),
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      validator: validator,
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
