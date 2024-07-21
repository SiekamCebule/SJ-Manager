import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.onChange,
    this.formatters,
    required this.labelText,
    this.focusNode,
    this.enabled = true,
  });

  final bool enabled;
  final VoidCallback onChange;
  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;
  final String labelText;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        label: Text(labelText),
        border: const OutlineInputBorder(),
      ),
      inputFormatters: formatters,
      onSubmitted: (value) => onChange(),
      onTapOutside: (event) => onChange(),
      focusNode: focusNode,
    );
  }
}
