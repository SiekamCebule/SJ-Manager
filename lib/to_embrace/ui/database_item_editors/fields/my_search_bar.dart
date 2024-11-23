import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    super.key,
    this.controller,
    this.autofocus = true,
    this.hintText,
    this.backgroundColor,
    this.onChanged,
  });

  final TextEditingController? controller;
  final bool autofocus;
  final String? hintText;
  final Color? backgroundColor;
  final Function(String text)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      onChanged: onChanged,
      backgroundColor: WidgetStatePropertyAll(backgroundColor),
      overlayColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return Theme.of(context).colorScheme.surfaceContainerLowest;
        } else {
          return Colors.transparent;
        }
      }),
      elevation: const WidgetStatePropertyAll(0),
      autoFocus: autofocus,
      hintText: hintText,
    );
  }
}
