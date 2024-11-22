part of '../../database_editor_page.dart';

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
    final itemsType = context.watch<DatabaseEditorItemsTypeCubit>().state.type;
    final selection = context.watch<DatabaseEditorSelectionCubit>().state.selection;

    return AppropriateItemEditor(
      key: widget.editorKey,
      itemType: itemsType,
      onChange: (changedItem) async {
        if (selection.length == 1 && changedItem != null) {
          context.read<DatabaseEditorItemsCubit>().updateItem(changedItem);
          //dbIsChangedCubit.markAsChanged(); // TODO
        }
      },
    );
  }
}
