part of '../../database_editor_screen.dart';

class ItemEditorNonEmptyStateBody extends StatelessWidget {
  const ItemEditorNonEmptyStateBody({
    super.key,
    required this.editorKey,
  });

  final GlobalKey<AppropriateItemEditorState> editorKey;

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsCubit>().state.itemsType;
    final dbIsChangedCubit = context.read<ChangeStatusCubit>();
    final selectedIndexesRepo = context.read<SelectedIndexesRepo>();
    final editableItemsRepo =
        context.watch<LocalDatabaseCopyCubit>().state!.getEditable(itemsType);

    return AppropriateItemEditor(
      key: editorKey,
      itemType: itemsType,
      onChange: (changedItem) async {
        if (selectedIndexesRepo.last.length == 1 && changedItem != null) {
          final index = selectedIndexesRepo.last.single;
          final idsRepo = context.read<ItemsIdsRepo>();
          print('previous item: ${editableItemsRepo.last[index]}');
          final previousItemId = idsRepo.idOf(editableItemsRepo.last[index]);
          print('previous id: $previousItemId');

          editableItemsRepo.replace(oldIndex: index, newItem: changedItem);

          idsRepo.removeById(id: previousItemId);

          final newId = context.read<IdGenerator>().generate();
          idsRepo.register(changedItem, id: newId);

          print(
              'items with previous id $previousItemId ${idsRepo.countOfItemsWithId(previousItemId)}');
          final maleJumpersInIdsRepo = Map.of(idsRepo.items);
          maleJumpersInIdsRepo.removeWhere((id, item) => item is Jumper == false);
          print('male jumpers in idsrepo: $maleJumpersInIdsRepo');

          dbIsChangedCubit.markAsChanged();
        }
      },
    );
  }
}
