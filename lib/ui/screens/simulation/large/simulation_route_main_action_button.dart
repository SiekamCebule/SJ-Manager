import 'package:flutter/material.dart';

class SimulationRouteMainActionButton extends StatelessWidget {
  const SimulationRouteMainActionButton({
    super.key,
    this.onPressed,
    required this.labelText,
    required this.iconData,
  });

  final VoidCallback? onPressed;
  final String labelText;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        splashFactory: InkRipple.splashFactory,
        minimumSize: const Size(100, 50),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      ),
      label: Text(
        labelText,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ),
      icon: Icon(
        iconData,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      iconAlignment: IconAlignment.end,
    );
  }
}
