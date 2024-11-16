import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class LinkTextButton extends StatelessWidget {
  const LinkTextButton({
    super.key,
    this.color,
    required this.onPressed,
    required this.labelText,
    this.textStyle,
    this.excludeIcon = false,
    this.iconSize,
    this.customIcon,
  });

  final Color? color;
  final VoidCallback? onPressed;
  final String labelText;
  final TextStyle? textStyle;
  final bool excludeIcon;
  final double? iconSize;
  final Widget? customIcon;

  @override
  Widget build(BuildContext context) {
    final finalColor = color ?? Theme.of(context).colorScheme.secondary;
    final icon = customIcon ??
        Icon(
          Symbols.arrow_forward_rounded,
          color: finalColor,
          size: iconSize,
        );
    final textWidget = Text(
      labelText,
      style: textStyle ??
          Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: finalColor,
              ),
    );
    return excludeIcon
        ? TextButton(
            onPressed: onPressed,
            child: textWidget,
          )
        : TextButton.icon(
            onPressed: onPressed,
            label: textWidget,
            icon: icon,
            iconAlignment: IconAlignment.end,
          );
  }
}
