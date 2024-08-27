part of '../../database_editor_screen.dart';

class _RemoveFab extends StatelessWidget {
  const _RemoveFab();

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsCubit>().state.itemsType;
    final selectedIndexesRepo = context.watch<SelectedIndexesRepo>();
    final dbChangeStatusCubit = context.watch<ChangeStatusCubit>();
    final copiedDbCubit = context.watch<LocalDatabaseCopyCubit>();

    final editableItemsForCurrentType = copiedDbCubit.state!.getEditable(itemsType);

    return StreamBuilder(
        stream: MergeStream([selectedIndexesRepo.selectedIndexes]),
        builder: (context, snapshot) {
          return FloatingActionButton(
            key: const ValueKey('removeFab'),
            heroTag: 'removeFab',
            backgroundColor: Theme.of(context)
                .colorScheme
                .tertiaryContainer
                .blendWithBg(Theme.of(context).brightness, 0.2),
            onPressed: () async {
              var subtraction = 0;
              for (var removeIndex in selectedIndexesRepo.state) {
                removeIndex -= subtraction;
                editableItemsForCurrentType.removeAt(removeIndex);
                subtraction += 1;
              }
              if (selectedIndexesRepo.state.length > 1 ||
                  editableItemsForCurrentType.items.value.isEmpty) {
                selectedIndexesRepo.clearSelection();
              } else if (selectedIndexesRepo.state.length == 1 &&
                  selectedIndexesRepo.state.single != 0) {
                selectedIndexesRepo.selectOnlyAt(selectedIndexesRepo.state.single - 1);
              }
              dbChangeStatusCubit.markAsChanged();
            },
            tooltip: translate(context).remove,
            child: const Icon(Symbols.remove),
          );
        });
  }
}
