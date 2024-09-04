part of '../../database_editor_screen.dart';

class ItemEditorEmptyStateBody extends StatelessWidget {
  const ItemEditorEmptyStateBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context)
        .colorScheme
        .onSurface
        .blendWithBg(Theme.of(context).brightness, 0.1);
    final textStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(color: color);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.edit,
            color: color,
            size: UiItemEditorsConstants.emptyStateIconSize,
          ),
          const Gap(10),
          Text(
            'Wybierz jakiś element, żeby go edytować',
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
