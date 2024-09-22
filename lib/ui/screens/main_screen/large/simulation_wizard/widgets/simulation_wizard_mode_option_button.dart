import 'package:flutter/material.dart';

class SimulationWizardModeOptionButton extends StatelessWidget {
  const SimulationWizardModeOptionButton({
    super.key,
    required this.titleText,
    required this.subtitleText,
    required this.onTap,
    this.leading,
    this.trailing,
    required this.isSelected,
  });

  final String titleText;
  final String subtitleText;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final titleColor = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;
    final titleStyle =
        Theme.of(context).textTheme.titleLarge!.copyWith(color: titleColor);
    return ListTile(
      title: Text(
        titleText,
        style: titleStyle,
      ),
      subtitle: Text(
        subtitleText,
      ),
      selectedColor: Theme.of(context).colorScheme.onSurfaceVariant,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      selected: isSelected,
      style: ListTileStyle.list,
      shape: Border.all(width: 0),
    );
  }
}
