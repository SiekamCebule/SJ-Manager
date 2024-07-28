part of '../../database_editor_screen.dart';

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _editorKey = GlobalKey<_AppropriateItemEditorState>();
  late final StreamSubscription _selectionChangesSubscription;

  @override
  void initState() {
    _setUpEditorFillingAfterSelectionChanges();
    super.initState();
  }

  void _setUpEditorFillingAfterSelectionChanges() {
    final filtersRepo = context.read<DbFiltersRepo>();
    final selectedIndexesRepo = context.read<SelectedIndexesRepo>();
    _selectionChangesSubscription =
        selectedIndexesRepo.selectedIndexes.distinct((prev, curr) {
      return prev == curr;
    }).listen((state) {
      if (selectedIndexesRepo.state.length == 1) {
        final index = selectedIndexesRepo.state.single;
        final itemsType = context.read<DatabaseItemsTypeCubit>().state;
        final originalByType = context.read<LocalDbRepo>().editableByType(itemsType);
        final filteredByType =
            context.read<LocalDbFilteredItemsCubit>().state.byType(itemsType);
        if (!filtersRepo.hasValidFilter) {
          final singleSelectedItem = filteredByType.elementAt(index);
          _fillEditorBySingleSelected(singleSelectedItem);
        } else {
          final singleSelectedItem = originalByType.last.elementAt(context
              .read<LocalDbFilteredItemsCubit>()
              .findOriginalIndex(index, itemsType));
          _fillEditorBySingleSelected(singleSelectedItem);
        }
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
          flex: 9,
          child: _ItemsList(),
        ),
        const Gap(UiDatabaseEditorConstants.horizontalSpaceBetweenListAndEditor),
        Expanded(
          flex: 7,
          child: Align(
            alignment: Alignment.topCenter,
            child: _AnimatedEditor(
              editorKey: _editorKey,
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
