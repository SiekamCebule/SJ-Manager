part of '../../database_editor_screen.dart';

class ItemEditorNonEmptyStateBody extends StatefulWidget {
  const ItemEditorNonEmptyStateBody({
    super.key,
    required this.editorKey,
  });

  final GlobalKey<AppropriateItemEditorState> editorKey;

  @override
  State<ItemEditorNonEmptyStateBody> createState() => _ItemEditorNonEmptyStateBodyState();
}

class _ItemEditorNonEmptyStateBodyState extends State<ItemEditorNonEmptyStateBody> {
  @override
  Widget build(BuildContext context) {
    final itemsCubit = context.watch<DatabaseItemsCubit>();
    final itemsType = itemsCubit.state.itemsType;
    final dbIsChangedCubit = context.read<ChangeStatusCubit>();
    final selectedIndexesRepo = context.read<SelectedIndexesRepo>();

    return AppropriateItemEditor(
      key: widget.editorKey,
      itemType: itemsType,
      onChange: (changedItem) async {
        if (selectedIndexesRepo.last.length == 1 && changedItem != null) {
          itemsCubit.replace(changedItem: changedItem);
          dbIsChangedCubit.markAsChanged();
        }
      },
    );
  }
}
