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
  });

  final Color? color;
  final VoidCallback onPressed;
  final String labelText;
  final TextStyle? textStyle;
  final bool excludeIcon;

  @override
  Widget build(BuildContext context) {
    final finalColor = color ?? Theme.of(context).colorScheme.secondary;
    final textWidget = Text(
      labelText,
      style: textStyle ??
          Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: finalColor,
              ),
    );
    final buttonStyle = TextButton.styleFrom(
      overlayColor: Colors.transparent,
    );

    return excludeIcon
        ? TextButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: textWidget,
          )
        : TextButton.icon(
            onPressed: onPressed,
            //style: buttonStyle,
            label: textWidget,
            icon: Icon(
              Symbols.arrow_forward_rounded,
              color: finalColor,
            ),
            iconAlignment: IconAlignment.end,
          );
  }
}
