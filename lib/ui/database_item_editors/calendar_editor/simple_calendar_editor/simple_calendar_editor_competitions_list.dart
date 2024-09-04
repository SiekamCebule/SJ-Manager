import 'package:flutter/material.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/ui/database_item_editors/calendar_editor/simple_calendar_editor/simple_calendar_editor_competition_record_tile.dart';

class SimpleCalendarEditorCompetitionsList extends StatelessWidget {
  const SimpleCalendarEditorCompetitionsList({
    super.key,
    required this.competitionRecords,
  });

  final List<CalendarMainCompetitionRecord> competitionRecords;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: competitionRecords.length,
      itemBuilder: (context, index) {
        return SimpleCalendarEditorCompetitionRecordTile(
          competitionRecord: competitionRecords[index],
        );
      },
    );
  }
}
