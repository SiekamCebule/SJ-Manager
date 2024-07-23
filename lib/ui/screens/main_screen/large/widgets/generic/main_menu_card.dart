import 'package:flutter/material.dart';

class MainMenuCard extends StatelessWidget {
  const MainMenuCard({
    super.key,
    this.onTap,
    required this.child,
    this.isSelected = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.surfaceContainer,
      child: InkWell(
        hoverColor: Theme.of(context).colorScheme.secondaryContainer,
        splashColor: Theme.of(context).colorScheme.secondaryContainer,
        highlightColor: Theme.of(context).colorScheme.secondaryContainer,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
