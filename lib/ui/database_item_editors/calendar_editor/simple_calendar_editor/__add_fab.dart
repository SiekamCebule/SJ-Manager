part of 'simple_calendar_editor_screen.dart';

class _AddFab extends StatelessWidget {
  const _AddFab();

  @override
  Widget build(BuildContext context) {
    final editingCubit = context.watch<SimpleCalendarEditingCubit>();
    final selectedIndexesRepo = context.watch<SelectedIndexesRepo>();
    final changeStatusCubit = context.watch<ChangeStatusCubit>();

    return StreamBuilder(
      stream: selectedIndexesRepo.stream,
      builder: (context, snapshot) {
        return FloatingActionButton(
          key: const ValueKey('addFab'),
          heroTag: 'addFab',
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          onPressed: () async {
            bool selectedExists = selectedIndexesRepo.last.length == 1;

            final lastIndex = editingCubit.state.competitionRecords.length;
            late int addIndex;
            if (selectedExists) {
              addIndex = selectedIndexesRepo.last.single + 1;
            } else {
              addIndex = lastIndex;
            }
            final defaultRecord =
                context.read<DefaultItemsRepo>().get<CalendarMainCompetitionRecord>();
            editingCubit.add(defaultRecord, addIndex);
            if (selectedExists) {
              selectedIndexesRepo.setSelection(addIndex - 1, false);
            }
            selectedIndexesRepo.setSelection(addIndex, true);
            changeStatusCubit.markAsChanged();
          },
        );
      },
    );
  }
}
