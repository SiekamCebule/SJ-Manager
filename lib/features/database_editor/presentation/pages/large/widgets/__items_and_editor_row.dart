part of '../../database_editor_page.dart';

class _ItemsAndEditorRow extends StatefulWidget {
  const _ItemsAndEditorRow();

  @override
  State<_ItemsAndEditorRow> createState() => _ItemsAndEditorRowState();
}

class _ItemsAndEditorRowState extends State<_ItemsAndEditorRow> {
  final _editorKey = GlobalKey<AppropriateItemEditorState>();
  late final StreamSubscription _selectionChangesSubscription;

  @override
  void initState() {
    _setUpEditorFillingAfterSelectionChanges();
    super.initState();
  }

  void _setUpEditorFillingAfterSelectionChanges() {
    final selectionCubit = context.watch<DatabaseEditorSelectionCubit>();
    _selectionChangesSubscription = selectionCubit.stream.distinct((prev, curr) {
      return prev == curr;
    }).listen((state) {
      final selection = selectionCubit.state.selection;
      if (selection.length == 1) {
        final selectedIndex = selection.single;
        if (!mounted) return;
        final itemsState = context.read<DatabaseEditorItemsCubit>().state;
        if (itemsState is! DatabaseEditorItemsInitialized) {
          throw StateError(
              'Selected an item but database editor items cubit has not been initialized');
        }
        final selectedItem = itemsState.items.elementAt(selectedIndex);
        _fillEditorBySingleSelected(selectedItem);
      }
    });
  }

  @override
  void dispose() {
    _selectionChangesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          flex: 10,
          child: _ItemsList(),
        ),
        const Gap(UiDatabaseEditorConstants.horizontalSpaceBetweenListAndEditor / 2),
        const VerticalDivider(),
        const Gap(UiDatabaseEditorConstants.horizontalSpaceBetweenListAndEditor / 2),
        Expanded(
          flex: 16,
          child: Align(
            alignment: Alignment.topCenter,
            child: DbEditorAnimatedEditor(
              emptyStateWidget: const ItemEditorEmptyStateBody(),
              nonEmptyStateWidget: ItemEditorNonEmptyStateBody(
                editorKey: _editorKey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _fillEditorBySingleSelected(singleSelectedItem) {
    _editorKey.currentState?.fill(singleSelectedItem);
  }
}
