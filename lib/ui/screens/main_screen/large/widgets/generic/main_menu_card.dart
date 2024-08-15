import 'package:flutter/material.dart';

class MainMenuCard extends StatelessWidget {
  const MainMenuCard({
    super.key,
    this.onTap,
    required this.child,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: InkWell(
        borderRadius: borderRadius,
        hoverColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        splashColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
