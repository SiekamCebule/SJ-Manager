import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.onChange,
    this.formatters,
    required this.labelText,
  });

  final VoidCallback onChange;
  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(labelText),
        border: const OutlineInputBorder(),
      ),
      inputFormatters: formatters,
      onSubmitted: (value) => onChange(),
      onTapOutside: (event) => onChange(),
    );
  }
}
