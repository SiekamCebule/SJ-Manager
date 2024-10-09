import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sj_manager/bloc/calendar_editing/simple_calendar_editing_cubit.dart';
import 'package:sj_manager/bloc/database_editing/change_status_cubit.dart';
import 'package:sj_manager/models/simulation/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/ui/database_item_editors/calendar_editor/simple_calendar_editor/simple_calendar_editor_competition_record_tile.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/ui/screens/database_editor/large/widgets/database_items_list.dart';

class SimpleCalendarEditorCompetitionsList extends StatelessWidget {
  const SimpleCalendarEditorCompetitionsList({
    super.key,
    required this.competitionRecords,
  });

  final List<CalendarMainCompetitionRecord> competitionRecords;

  @override
  Widget build(BuildContext context) {
    final selectedIndexesRepo = context.read<SelectedIndexesRepo>();
    return StreamBuilder(
      stream: selectedIndexesRepo.stream,
      builder: (context, snapshot) {
        return DatabaseItemsList(
          length: competitionRecords.length,
          onReorder: (oldIndex, newIndex) {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            context
                .read<SimpleCalendarEditingCubit>()
                .moveCompetition(from: oldIndex, to: newIndex);
            selectedIndexesRepo.moveSelection(from: oldIndex, to: newIndex);
            context.read<ChangeStatusCubit>().markAsChanged();
          },
          reorderable: true,
          itemBuilder: (context, index) {
            return SimpleCalendarEditorCompetitionRecordTile(
              key: ValueKey(index),
              competitionRecord: competitionRecords[index],
              selected: selectedIndexesRepo.last.contains(index),
              onItemTap: () {
                bool ctrlIsPressed = HardwareKeyboard.instance.isControlPressed;
                if (ctrlIsPressed) {
                  selectedIndexesRepo.toggleSelection(index);
                } else {
                  selectedIndexesRepo.toggleSelectionAtOnly(index);
                }
              },
              reorderable: true,
              indexInList: index,
            );
          },
        );
      },
    );
  }
}
