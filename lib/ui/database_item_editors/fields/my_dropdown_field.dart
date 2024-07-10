import 'package:flutter/material.dart';

class MyDropdownField<T> extends StatelessWidget {
  const MyDropdownField({
    super.key,
    this.controller,
    required this.onChange,
    this.initial,
    this.width,
    required this.entries,
    this.label,
    this.focusNode,
  });

  final TextEditingController? controller;
  final T? initial;
  final Function(T? selected) onChange;
  final double? width;
  final List<DropdownMenuEntry<T>> entries;
  final Widget? label;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      width: width,
      controller: controller,
      initialSelection: initial,
      enableSearch: false,
      requestFocusOnTap: false,
      dropdownMenuEntries: entries,
      label: label,
      onSelected: onChange,
      focusNode: focusNode,
    );
  }
}
