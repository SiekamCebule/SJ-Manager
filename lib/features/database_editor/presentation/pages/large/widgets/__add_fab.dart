part of '../../database_editor_page.dart';

class _AddFab extends StatelessWidget {
  const _AddFab();

  @override
  Widget build(BuildContext context) {
    final items = context.watch<DatabaseEditorItemsCubit>();
    DatabaseEditorItemsState itemsState = items.state;
    if (itemsState is! DatabaseEditorItemsInitialized) {
      throw StateError('Database editor items are uninitialized');
    }
    final changeStatus = context.watch<DatabaseEditorChangeStatusCubit>();

    return FloatingActionButton(
      key: const ValueKey('addFab'),
      heroTag: 'addFab',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      onPressed: () async {
        await items.addItem();
        await changeStatus.markAsChanged();
      },
      tooltip: translate(context).add,
      child: const Icon(Symbols.add),
    );
  }
}
