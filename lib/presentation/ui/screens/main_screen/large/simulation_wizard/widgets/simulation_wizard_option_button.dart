import 'package:flutter/material.dart';
import 'package:sj_manager/utilities/utils/colors.dart';

class SimulationWizardOptionButton extends StatelessWidget {
  const SimulationWizardOptionButton({
    super.key,
    required this.child,
    this.onTap,
    required this.isSelected,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Material(
      borderRadius: borderRadius,
      color: isSelected
          ? Theme.of(context).colorScheme.secondaryContainer.blendWithBg(brightness, 0.06)
          : Theme.of(context).colorScheme.surfaceContainer,
      child: InkWell(
        borderRadius: borderRadius,
        hoverColor: isSelected
            ? Theme.of(context)
                .colorScheme
                .secondaryContainer
                .blendWithBg(brightness, 0.10)
            : Theme.of(context).colorScheme.surfaceContainerLowest,
        splashColor: isSelected
            ? Theme.of(context)
                .colorScheme
                .secondaryContainer
                .blendWithBg(brightness, 0.01)
            : Theme.of(context).colorScheme.surfaceContainerHigh,
        highlightColor: isSelected
            ? Theme.of(context)
                .colorScheme
                .secondaryContainer
                .blendWithBg(brightness, -0.02)
            : Theme.of(context).colorScheme.surfaceContainerHigh,
        onTap: onTap ?? () {},
        child: child,
      ),
    );
  }
}
