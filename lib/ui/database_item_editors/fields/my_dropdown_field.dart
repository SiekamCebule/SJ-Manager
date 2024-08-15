import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
        enableFilter: true,
        onSelected: onChange,
        menuStyle: MenuStyle(
          visualDensity: VisualDensity.standard,
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ));
  }
}
