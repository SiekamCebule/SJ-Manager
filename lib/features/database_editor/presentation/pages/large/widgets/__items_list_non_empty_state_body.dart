part of '../../database_editor_page.dart';

class _ItemsListNonEmptyStateBody extends StatelessWidget {
  const _ItemsListNonEmptyStateBody();

  @override
  Widget build(BuildContext context) {
    final itemsCubit = context.watch<DatabaseEditorItemsCubit>();
    final itemsState = itemsCubit.state;
    if (itemsState is! DatabaseEditorItemsInitialized) {
      return const SizedBox();
    }
    final filtersState = context.watch<DatabaseEditorFiltersCubit>().state;
    final itemsType = context.watch<DatabaseEditorItemsTypeCubit>().state.type;
    final selection = context.watch<DatabaseEditorSelectionCubit>().state.selection;
    return DatabaseItemsList(
      reorderable: !filtersState.validFilterExists,
      onReorder: (oldIndex, newIndex) async {
        itemsCubit.moveItem(oldIndex, newIndex);
      },
      length: itemsState.items.length,
      itemBuilder: (context, index) {
        return AppropriateDbItemListTile(
          key: ValueKey(index),
          reorderable: !filtersState.validFilterExists,
          itemType: itemsType,
          item: itemsState.items.elementAt(index),
          indexInList: index,
          onItemTap: () async {
            bool ctrlIsPressed = HardwareKeyboard.instance.isControlPressed;
            bool shiftIsPressed = HardwareKeyboard.instance.isShiftPressed;
            if (shiftIsPressed && selection.length == 1) {
              final singleSelected = selection.single;
              final first = min(singleSelected, index);
              final last = max(singleSelected, index);
              context.read<DatabaseEditorSelectionCubit>().selectRange(first, last);
            } else if (ctrlIsPressed) {
              context.read<DatabaseEditorSelectionCubit>().toggle(index);
            } else {
              context.read<DatabaseEditorSelectionCubit>().toggle(index);
            }
          },
          selected: selection.contains(index),
        );
      },
    );
  }
}
