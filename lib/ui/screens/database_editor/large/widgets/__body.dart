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
      final bloc = context.read<DatabaseEditingCubit>();
      _selectionChangesSubscription = bloc.stream.distinct((prev, curr) {
        return prev.selectedIndexes == curr.selectedIndexes;
      }).listen((state) {
        if (bloc.state.selectedIndexes.length == 1) {
          final index = bloc.state.selectedIndexes.single;
          final singleSelectedItem = bloc.state.itemsForEditing.elementAt(index);
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
    final dbEditingCubit = context.watch<DatabaseEditingCubit>();
    DatabaseEditingState dbEditingState() => dbEditingCubit.state;

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
                await dbEditingCubit.move(from: oldIndex, to: newIndex);
              },
              length: dbEditingState().itemsForEditing.length,
              itemBuilder: (context, index) {
                return AppropiateDbItemListTile(
                  key: ValueKey(index),
                  itemType: dbEditingState().itemsType,
                  item: dbEditingState().itemsForEditing.elementAt(index),
                  indexInList: index,
                  onItemTap: () async {
                    if (_ctrlIsPressed) {
                      dbEditingCubit.toggleSelection(index);
                    } else {
                      dbEditingCubit.toggleOnly(index);
                    }
                  },
                  selected: dbEditingState().selectedIndexes.contains(index),
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
            opacity: dbEditingState().selectedIndexes.length == 1 ? 1 : 0,
            child: _AppropiateItemEditor(
              key: _editorKey,
              itemType: dbEditingState().itemsType,
              onChange: (changedItem) async {
                if (dbEditingState().selectedIndexes.length == 1) {
                  final index = dbEditingState().selectedIndexes.single;
                  await dbEditingCubit.update(index, changedItem);
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
