part of '../../database_editor_page.dart';

class _RemoveFab extends StatelessWidget {
  const _RemoveFab();

  @override
  Widget build(BuildContext context) {
    final items = context.watch<DatabaseEditorItemsCubit>();
    DatabaseEditorItemsState itemsState = items.state;
    if (itemsState is! DatabaseEditorItemsInitialized) {
      throw StateError('Database editor items are uninitialized');
    }
    final changeStatus = context.watch<DatabaseEditorChangeStatusCubit>();

    return FloatingActionButton(
      key: const ValueKey('removeFab'),
      heroTag: 'removeFab',
      backgroundColor: Theme.of(context)
          .colorScheme
          .tertiaryContainer
          .blendWithBg(Theme.of(context).brightness, 0.2),
      onPressed: () async {
        await items.add();
        await changeStatus.markAsChanged();
      },
      tooltip: translate(context).remove,
      child: const Icon(Symbols.remove),
    );
  }
}
