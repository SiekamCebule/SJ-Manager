part of 'simple_calendar_editor_screen.dart';

class _RemoveFab extends StatelessWidget {
  const _RemoveFab({
    this.additionalOnTap,
  });

  final VoidCallback? additionalOnTap;

  @override
  Widget build(BuildContext context) {
    final editingCubit = context.watch<SimpleCalendarEditingCubit>();
    final selectedIndexesRepo = context.watch<SelectedIndexesRepo>();
    final changeStatusCubit = context.watch<ChangeStatusCubit>();

    return StreamBuilder(
      stream: selectedIndexesRepo.stream,
      builder: (context, snapshot) {
        return FloatingActionButton(
          key: const ValueKey('removeFab'),
          heroTag: 'removeFab',
          backgroundColor: Theme.of(context)
              .colorScheme
              .tertiaryContainer
              .blendWithBg(Theme.of(context).brightness, 0.2),
          onPressed: () async {
            var subtraction = 0;
            for (var removeIndex in selectedIndexesRepo.last) {
              removeIndex -= subtraction;
              editingCubit.removeCompetitionAt(removeIndex);
              await Future.delayed(Duration.zero);
              if (!context.mounted) return;
              subtraction += 1;
            }
            if (selectedIndexesRepo.last.length > 1 ||
                editingCubit.state.competitionRecords.isEmpty) {
              selectedIndexesRepo.clearSelection();
            } else if (selectedIndexesRepo.last.length == 1 &&
                selectedIndexesRepo.last.single != 0) {
              selectedIndexesRepo.selectOnlyAt(selectedIndexesRepo.last.single - 1);
            }
            changeStatusCubit.markAsChanged();
            additionalOnTap?.call();
          },
          tooltip: translate(context).remove,
          child: const Icon(Symbols.remove),
        );
      },
    );
  }
}
