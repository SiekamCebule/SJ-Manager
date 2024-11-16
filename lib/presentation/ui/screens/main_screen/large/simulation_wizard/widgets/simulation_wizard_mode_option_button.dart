import 'package:flutter/material.dart';
import 'package:sj_manager/utilities/utils/colors.dart';

class SimulationWizardModeOptionButton extends StatelessWidget {
  const SimulationWizardModeOptionButton({
    super.key,
    required this.titleText,
    required this.subtitleText,
    required this.onTap,
    this.leading,
    this.trailing,
    required this.isSelected,
    this.disabled = true,
  });

  final String titleText;
  final String subtitleText;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final correctOnTap = disabled ? null : onTap;
    late final Color titleColor;
    if (disabled) {
      titleColor = Theme.of(context)
          .colorScheme
          .onSurfaceVariant
          .blendWithBg(Theme.of(context).brightness, 0.15);
    } else {
      titleColor = isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurface;
    }
    final titleStyle =
        Theme.of(context).textTheme.titleLarge!.copyWith(color: titleColor);
    return ListTile(
      enabled: !disabled,
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
      onTap: correctOnTap,
      selected: isSelected,
      style: ListTileStyle.list,
      shape: Border.all(width: 0),
    );
  }
}
