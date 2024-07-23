part of '../../database_editor_screen.dart';

class _AnimatedEditor extends StatelessWidget {
  const _AnimatedEditor({
    this.editorKey,
  });

  final GlobalKey<_AppropiateItemEditorState>? editorKey;

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsTypeCubit>().state;

    final copiedLocalDbCubit = context.read<CopiedLocalDbCubit>();
    final copiedLocalDbRepos = copiedLocalDbCubit.state!;
    final editableItemsRepoByType = copiedLocalDbRepos.editableByType(itemsType);

    final filtersRepo = context.read<DbFiltersRepo>();
    final selectedIndexesRepo = context.read<SelectedIndexesRepo>();
    final dbIsChangedCubit = context.read<ChangeStatusCubit>();
    final filteredItemsCubit = context.read<LocalDbFilteredItemsCubit>();

    return StreamBuilder(
      stream: MergeStream([
        selectedIndexesRepo.selectedIndexes,
        editableItemsRepoByType.items,
        filtersRepo.byType(itemsType),
      ]),
      builder: (context, snapshot) {
        final editorShouldBeVisible = selectedIndexesRepo.state.length == 1;
        return AnimatedVisibility(
          duration: Durations.medium1,
          curve: Curves.easeIn,
          visible: editorShouldBeVisible,
          child: _AppropiateItemEditor(
            key: editorKey,
            itemType: itemsType,
            onChange: (changedItem) async {
              if (selectedIndexesRepo.state.length == 1 && changedItem != null) {
                if (!filtersRepo.hasValidFilter) {
                  final index = selectedIndexesRepo.state.single;
                  editableItemsRepoByType.replace(oldIndex: index, newItem: changedItem);
                  dbIsChangedCubit.markAsChanged();
                } else {
                  final indexInFiltered = selectedIndexesRepo.state.single;
                  final indexInOriginal =
                      filteredItemsCubit.findOriginalIndex(indexInFiltered, itemsType);
                  editableItemsRepoByType.replace(
                      oldIndex: indexInOriginal, newItem: changedItem);
                  dbIsChangedCubit.markAsChanged();
                }
              }
            },
          ),
        );
      },
    );
  }
}
