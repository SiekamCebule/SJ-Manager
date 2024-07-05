part of '../../main_screen.dart';

class _Button extends StatelessWidget {
  const _Button({
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
        hoverColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        splashColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
