import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    super.key,
    this.controller,
    this.autofocus = true,
    this.hintText,
    this.backgroundColor,
  });

  final TextEditingController? controller;
  final bool autofocus;
  final String? hintText;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
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
