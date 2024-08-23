import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';

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

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(UiFieldWidgetsConstants.borderRadius),
      borderSide: BorderSide(
        width: UiFieldWidgetsConstants.borderSideWidth,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
    return TextFormField(
      key: textFormFieldKey,
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        label: Text(labelText),
        enabledBorder: border,
        border: border,
        errorMaxLines: errorMaxLines,
      ),
      inputFormatters: formatters,
      onEditingComplete: () => onChange(),
      onTapOutside: (event) => onChange(),
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      validator: validator,
      focusNode: focusNode,
    );
  }
}
