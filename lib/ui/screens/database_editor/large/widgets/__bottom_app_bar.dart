part of '../../database_editor_screen.dart';

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: BlocBuilder<DatabaseItemsTypeCubit, DbEditableItemType>(
        builder: (context, itemsType) {
          return switch (itemsType) {
            DbEditableItemType.maleJumper => const _ForJumpers(),
            DbEditableItemType.femaleJumper => const _ForJumpers(),
            DbEditableItemType.hill => const _ForHills(),
            DbEditableItemType.eventSeriesSetup => const SizedBox(),
            DbEditableItemType.eventSeriesCalendarPreset => const SizedBox(),
            DbEditableItemType.competitionRulesPreset => const SizedBox(),
          };
        },
      ),
    );
  }
}
