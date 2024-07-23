import 'package:flutter/material.dart';

class MainMenuCard extends StatelessWidget {
  const MainMenuCard({
    super.key,
    this.onTap,
    required this.child,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: InkWell(
        hoverColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        splashColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        highlightColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
