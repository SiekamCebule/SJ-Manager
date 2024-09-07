import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/repositories/database_editing/selected_indexes_repository.dart';
import 'package:sj_manager/ui/database_item_editors/calendar_editor/simple_calendar_editor/simple_calendar_editor_competition_record_tile.dart';
import 'package:provider/provider.dart';

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
        return ListView.builder(
          itemCount: competitionRecords.length,
          itemBuilder: (context, index) {
            return SimpleCalendarEditorCompetitionRecordTile(
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
