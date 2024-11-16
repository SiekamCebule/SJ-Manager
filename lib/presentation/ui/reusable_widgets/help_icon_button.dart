import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HelpIconButton extends StatelessWidget {
  const HelpIconButton({
    super.key,
    required this.onPressed,
    this.iconSize,
  });

  final VoidCallback onPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Dowiedz się więcej',
      onPressed: onPressed,
      icon: Icon(
        Symbols.help,
        size: iconSize,
      ),
    );
  }
}
