part of '../../database_editor_screen.dart';

class _AddFab extends StatelessWidget {
  const _AddFab();

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsCubit>().state.itemsType;
    final selectedIndexesRepo = context.watch<SelectedIndexesRepo>();
    final itemsCubit = context.watch<DatabaseItemsCubit>();
    final itemsState = itemsCubit.state;
    final itemsLength =
        itemsState is DatabaseItemsNonEmpty ? itemsState.filteredItems.length : 0;
    final dbChangeStatusCubit = context.watch<ChangeStatusCubit>();
    final copiedDbCubit = context.watch<LocalDatabaseCopyCubit>();

    final editableItemsForCurrentType = copiedDbCubit.state!.getEditable(itemsType);
    final defaultItems = context.watch<DefaultItemsRepo>();

    return StreamBuilder<Object>(
        stream: MergeStream([
          selectedIndexesRepo.stream,
          editableItemsForCurrentType.items,
        ]),
        builder: (context, snapshot) {
          return FloatingActionButton(
            key: const ValueKey('addFab'),
            heroTag: 'addFab',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            onPressed: () async {
              bool selectedExists = selectedIndexesRepo.last.length == 1;

              final lastIndex = itemsLength;
              late int addIndex;
              if (selectedExists) {
                addIndex = selectedIndexesRepo.last.single + 1;
              } else {
                addIndex = lastIndex;
              }
              var ensuredType = itemsType == EventSeriesCalendarPreset
                  ? SimpleEventSeriesCalendarPreset
                  : itemsType;

              final itemToAdd = defaultItems.getByTypeArgument(ensuredType);
              editableItemsForCurrentType.add(itemToAdd, addIndex);
              final idsRepo = context.read<ItemsIdsRepo>();
              idsRepo.register(
                itemToAdd,
                id: context.read<IdGenerator>().generate(),
              );

              if (selectedExists) {
                selectedIndexesRepo.setSelection(addIndex - 1, false);
              }
              selectedIndexesRepo.setSelection(addIndex, true);
              dbChangeStatusCubit.markAsChanged();
            },
            tooltip: translate(context).add,
            child: const Icon(Symbols.add),
          );
        });
  }
}
