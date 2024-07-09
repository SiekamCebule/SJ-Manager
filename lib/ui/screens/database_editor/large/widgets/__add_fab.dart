part of '../../database_editor_screen.dart';

class _AddFab extends StatelessWidget {
  const _AddFab();

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsTypeCubit>().state;
    final selectedIndexesRepo = context.watch<SelectedIndexesRepository>();
    final filteredItems = context.watch<LocalDbFilteredItemsCubit>().state;
    final dbChangeStatusCubit = context.watch<ChangeStatusCubit>();
    final copiedDbCubit = context.watch<CopiedLocalDbCubit>();

    final editableItemsForCurrentType = copiedDbCubit.state!.byType(itemsType);
    final defaultItems = context.watch<DefaultItemsRepository>();

    return StreamBuilder<Object>(
        stream: MergeStream([
          selectedIndexesRepo.selectedIndexes,
          editableItemsForCurrentType.items,
        ]),
        builder: (context, snapshot) {
          return FloatingActionButton(
            heroTag: 'FABadd',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            onPressed: () async {
              bool selectedExists = selectedIndexesRepo.state.length == 1;
              final lastIndex = filteredItems.byType(itemsType).length;
              late int addIndex;
              if (selectedExists) {
                addIndex = selectedIndexesRepo.state.single + 1;
              } else {
                addIndex = lastIndex;
              }
              editableItemsForCurrentType.add(
                defaultItems.byDatabaseItemType(itemsType),
                addIndex,
              );

              if (selectedExists) {
                selectedIndexesRepo.setSelection(addIndex - 1, false);
              }
              selectedIndexesRepo.setSelection(addIndex, true);
              dbChangeStatusCubit.markAsChanged();
            },
            tooltip: 'Dodaj',
            child: const Icon(Symbols.add),
          );
        });
  }
}
