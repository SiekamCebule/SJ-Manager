part of '../../database_editor_screen.dart';

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _editorKey = GlobalKey<_AppropiateItemEditorState>();
  bool _ctrlIsPressed = false;
  late final StreamSubscription _selectionChangesSubscription;

  @override
  void initState() {
    scheduleMicrotask(() async {
      final selectedIndexesRepo = context.read<SelectedIndexesRepository>();
      _selectionChangesSubscription =
          selectedIndexesRepo.selectedIndexes.distinct((prev, curr) {
        return prev == curr;
      }).listen((state) {
        if (selectedIndexesRepo.state.length == 1) {
          final index = selectedIndexesRepo.state.single;
          final itemsType = context.read<DatabaseItemsTypeCubit>().state;
          final filteredByType =
              context.read<LocalDbFilteredItemsCubit>().state.byType(itemsType);
          final singleSelectedItem = filteredByType.elementAt(index);
          _fillEditorBySingleSelected(singleSelectedItem);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _selectionChangesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsTypeCubit>().state;
    final editableItemsRepoByType =
        context.watch<LocalDbReposRepository>().byType(itemsType);
    final filteredItemsByType =
        context.watch<LocalDbFilteredItemsCubit>().state.byType(itemsType);
    final selectedIndexesRepo = context.watch<SelectedIndexesRepository>();

    return Row(
      children: [
        Expanded(
          flex: 13,
          child: Focus(
            autofocus: true,
            onKeyEvent: (node, event) {
              _ctrlIsPressed = HardwareKeyboard.instance.isControlPressed;
              return KeyEventResult.ignored;
            },
            child: ReorderableDatabaseItemsList(
              onReorder: (oldIndex, newIndex) async {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                await editableItemsRepoByType.move(from: oldIndex, to: newIndex);
              },
              length: filteredItemsByType.length,
              itemBuilder: (context, index) {
                return AppropiateDbItemListTile(
                  key: ValueKey(index),
                  itemType: itemsType,
                  item: filteredItemsByType.elementAt(index),
                  indexInList: index,
                  onItemTap: () async {
                    if (_ctrlIsPressed) {
                      selectedIndexesRepo.toggleSelection(index);
                    } else {
                      selectedIndexesRepo.toggleSelectionAtOnly(index);
                    }
                  },
                  selected: selectedIndexesRepo.state.contains(index),
                );
              },
            ),
          ),
        ),
        const Gap(45),
        Expanded(
          flex: 7,
          child: AnimatedOpacity(
            duration: Durations.short3,
            curve: Curves.easeIn,
            opacity: selectedIndexesRepo.state.length == 1 ? 1 : 0,
            child: _AppropiateItemEditor(
              key: _editorKey,
              itemType: itemsType,
              onChange: (changedItem) async {
                if (selectedIndexesRepo.state.length == 1 && changedItem != null) {
                  final index = selectedIndexesRepo.state.single;
                  await editableItemsRepoByType.replace(
                      oldIndex: index, newItem: changedItem);
                }
              },
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
