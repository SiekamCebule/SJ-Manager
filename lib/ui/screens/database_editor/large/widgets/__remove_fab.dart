part of '../../database_editor_screen.dart';

class _RemoveFab extends StatelessWidget {
  const _RemoveFab();

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsTypeCubit>().state;
    final selectedIndexesRepo = context.watch<SelectedIndexesRepository>();
    final dbChangeStatusCubit = context.watch<ChangeStatusCubit>();
    final copiedDbCubit = context.watch<CopiedLocalDbCubit>();

    final editableItemsForCurrentType = copiedDbCubit.state!.byType(itemsType);

    return StreamBuilder(
        stream: MergeStream([selectedIndexesRepo.selectedIndexes]),
        builder: (context, snapshot) {
          return FloatingActionButton(
            heroTag: 'FABremove',
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
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
            tooltip: 'Usuń',
            child: const Icon(Symbols.remove),
          );
        });
  }
}
