part of '../../database_editor_screen.dart';

class _AddFab extends StatelessWidget {
  const _AddFab();

  @override
  Widget build(BuildContext context) {
    final itemsType = context.watch<DatabaseItemsCubit>().state.itemsType;
    final selectedIndexesRepo = context.watch<SelectedIndexesRepo>();
    final itemsCubit = context.watch<DatabaseItemsCubit>();
    final dbChangeStatusCubit = context.watch<ChangeStatusCubit>();
    final defaultItems = context.watch<DefaultItemsRepo>();

    return StreamBuilder<Object>(
        stream: MergeStream([
          selectedIndexesRepo.stream,
        ]),
        builder: (context, snapshot) {
          return FloatingActionButton(
            key: const ValueKey('addFab'),
            heroTag: 'addFab',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            onPressed: () async {
              var ensuredType = itemsType == EventSeriesCalendarPreset
                  ? SimpleEventSeriesCalendarPreset
                  : itemsType;

              final itemToAdd = defaultItems.getByTypeArgument(ensuredType);
              itemsCubit.add(item: itemToAdd);
              dbChangeStatusCubit.markAsChanged();
            },
            tooltip: translate(context).add,
            child: const Icon(Symbols.add),
          );
        });
  }
}
