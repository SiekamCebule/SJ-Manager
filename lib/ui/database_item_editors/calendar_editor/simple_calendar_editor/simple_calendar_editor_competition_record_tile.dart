import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class SimpleCalendarEditorCompetitionRecordTile extends StatelessWidget {
  const SimpleCalendarEditorCompetitionRecordTile({
    super.key,
    required this.competitionRecord,
  });

  final CalendarMainCompetitionRecord competitionRecord;

  @override
  Widget build(BuildContext context) {
    final competitionIsTeam =
        competitionRecord.setup.mainCompRules is DefaultCompetitionRules<Jumper>;
    return ListTile(
      title: SizedBox(width: 100, child: Text(competitionRecord.hill.toString())),
      leading: competitionIsTeam ? const Icon(Symbols.group) : const Icon(Symbols.person),
      trailing: Row(
        children: [
          Text('2'),
          Icon(Symbols.check),
          Icon(Symbols.cabin),
        ],
      ),
    );
  }
}
