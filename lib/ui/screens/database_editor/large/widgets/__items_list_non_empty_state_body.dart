part of '../../database_editor_screen.dart';

class _ItemsListNonEmptyStateBody extends StatelessWidget {
  const _ItemsListNonEmptyStateBody();

  @override
  Widget build(BuildContext context) {
    final itemsCubit = context.watch<DatabaseItemsCubit>();
    final itemsState = itemsCubit.state;
    if (itemsState is DatabaseItemsEmpty) {
      return const SizedBox();
    }
    final itemsStateNonEmpty = itemsState as DatabaseItemsNonEmpty;
    final itemsType = itemsStateNonEmpty.itemsType;
    final selectedIndexesRepo = context.watch<SelectedIndexesRepo>();
    final dbIsChangedCubit = context.watch<ChangeStatusCubit>();

    final listShouldBeReorderable = !itemsStateNonEmpty.hasValidFilters;

    return StreamBuilder(
        stream: selectedIndexesRepo.stream,
        builder: (context, snapshot) {
          return DatabaseItemsList(
            reorderable: listShouldBeReorderable,
            onReorder: (oldIndex, newIndex) async {
              itemsCubit.move(from: oldIndex, to: newIndex);
              dbIsChangedCubit.markAsChanged();
            },
            length: itemsStateNonEmpty.filteredItems.length,
            itemBuilder: (context, index) {
              return AppropriateDbItemListTile(
                key: ValueKey(index),
                reorderable: listShouldBeReorderable,
                itemType: itemsType,
                item: itemsStateNonEmpty.filteredItems.elementAt(index),
                indexInList: index,
                onItemTap: () async {
                  bool ctrlIsPressed = HardwareKeyboard.instance.isControlPressed;
                  if (ctrlIsPressed) {
                    selectedIndexesRepo.toggleSelection(index);
                  } else {
                    selectedIndexesRepo.toggleSelectionAtOnly(index);
                  }
                },
                selected: selectedIndexesRepo.last.contains(index),
              );
            },
          );
        });
  }
}
