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
          final previousItemId = idsRepo.idOf(editableItemsRepo.last[index]);
          editableItemsRepo.replace(oldIndex: index, newItem: changedItem);
          context.read<ItemsIdsRepo>().update(
                id: previousItemId,
                newItem: changedItem,
              );
          dbIsChangedCubit.markAsChanged();
        }
      },
    );
  }
}
