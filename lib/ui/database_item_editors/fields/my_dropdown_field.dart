import 'package:flutter/material.dart';

class MyDropdownField<T> extends StatelessWidget {
  const MyDropdownField({
    super.key,
    this.controller,
    required this.onChange,
    this.initial,
    this.width,
    required this.entries,
    this.leadingIcon,
    this.trailingIcon,
    this.label,
    this.enableSearch,
    this.enabled,
  });

  final TextEditingController? controller;
  final T? initial;
  final Function(T? selected) onChange;
  final double? width;
  final List<DropdownMenuEntry<T>> entries;
  final Widget? label;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool? enableSearch;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    print('dropdown build');
    return DropdownMenu<T>(
      enabled: enabled ?? true,
      enableSearch: enableSearch ?? true,
      requestFocusOnTap: false,
      width: width,
      controller: controller,
      initialSelection: initial,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      dropdownMenuEntries: entries,
      label: label,
      onSelected: onChange,
    );
  }
}
