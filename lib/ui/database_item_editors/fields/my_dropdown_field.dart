import 'package:flutter/material.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/reusable_widgets/help_icon_button.dart';
import 'package:sj_manager/utils/colors.dart';

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
    this.enableSearch = true,
    this.enabled = true,
    this.menuHeight,
    this.requestFocusOnTap = false,
    this.focusNode,
    this.onHelpButtonTap,
    this.alignmentOffset,
  });

  final TextEditingController? controller;
  final T? initial;
  final Function(T? selected) onChange;
  final double? width;
  final List<DropdownMenuEntry<T>> entries;
  final Widget? label;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool enableSearch;
  final bool enabled;
  final double? menuHeight;
  final bool requestFocusOnTap;
  final FocusNode? focusNode;
  final VoidCallback? onHelpButtonTap;
  final Offset? alignmentOffset;

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
    final field = DropdownMenu<T>(
      enabled: enabled,
      enableSearch: enableSearch,
      requestFocusOnTap: requestFocusOnTap,
      width: width,
      alignmentOffset: alignmentOffset,
      controller: controller,
      initialSelection: initial,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      dropdownMenuEntries: entries,
      textStyle: enabled
          ? null
          : Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .blendWithBg(Theme.of(context).brightness, 0.2),
              ),
      label: label,
      enableFilter: true,
      onSelected: onChange,
      inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
            enabledBorder: border,
            border: border,
          ),
      menuHeight: menuHeight,
      menuStyle: MenuStyle(
        visualDensity: VisualDensity.standard,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );

    return showHelpButton
        ? Row(
            children: [
              Expanded(child: field),
              HelpIconButton(onPressed: onHelpButtonTap!),
            ],
          )
        : field;
  }
}
