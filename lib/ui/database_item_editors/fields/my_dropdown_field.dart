import 'package:flutter/material.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';

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
    final border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(UiFieldWidgetsConstants.borderRadius),
      borderSide: BorderSide(
        width: UiFieldWidgetsConstants.borderSideWidth,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
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
        inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
              enabledBorder: border,
              border: border,
            ),
        menuStyle: MenuStyle(
          visualDensity: VisualDensity.standard,
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ));
  }
}
