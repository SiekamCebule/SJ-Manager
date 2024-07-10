part of '../../database_editor_screen.dart';

class _ItemsList extends StatefulWidget {
  const _ItemsList();

  @override
  State<_ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<_ItemsList> {
  bool _ctrlIsPressed = false;

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsTypeCubit>().state;
    final copiedLocalDbCubit = context.watch<CopiedLocalDbCubit>();
    final copiedLocalDbRepos = copiedLocalDbCubit.state!;

    final editableItemsRepoByType = copiedLocalDbRepos.byType(itemsType);
    final filtersRepo = context.watch<DbFiltersRepository>();
    final selectedIndexesRepo = context.watch<SelectedIndexesRepository>();

    final filteredItemsByType =
        context.watch<LocalDbFilteredItemsCubit>().state.byType(itemsType);
    final dbIsChangedCubit = context.watch<ChangeStatusCubit>();

    return StreamBuilder(
        stream: StreamGroup.merge([
          selectedIndexesRepo.selectedIndexes,
          editableItemsRepoByType.items,
        ]),
        builder: (context, snapshot) {
          final listShouldBeReorderable = !filtersRepo.hasValidFilter;
          return Focus(
            autofocus: true,
            onKeyEvent: (node, event) {
              _ctrlIsPressed = HardwareKeyboard.instance.isControlPressed;
              return KeyEventResult.ignored;
            },
            child: DatabaseItemsList(
              reorderable: listShouldBeReorderable,
              onReorder: (oldIndex, newIndex) async {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                await editableItemsRepoByType.move(from: oldIndex, to: newIndex);
                dbIsChangedCubit.markAsChanged();
              },
              length: filteredItemsByType.length,
              itemBuilder: (context, index) {
                return AppropiateDbItemListTile(
                  key: ValueKey(index),
                  reorderable: listShouldBeReorderable,
                  itemType: itemsType,
                  item: filteredItemsByType.elementAt(index),
                  indexInList: index,
                  onItemTap: () async {
                    if (_ctrlIsPressed) {
                      selectedIndexesRepo.toggleSelection(index);
                    } else {
                      selectedIndexesRepo.toggleSelectionAtOnly(index);
                    }
                  },
                  selected: selectedIndexesRepo.state.contains(index),
                );
              },
            ),
          );
        });
  }
}
