import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/models/db/event_series/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/db/event_series/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/db/event_series/competition/calendar_records/calendar_main_competition_records_to_calendar.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/individual_competition_rules.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/team_competition_rules.dart';
import 'package:sj_manager/models/db/hill/hill.dart';

void main() {
  group(CalendarMainCompetitionRecordsToCalendarConveter(), () {
    final zakopane = const Hill.empty(country: Country.emptyNone())
        .copyWith(locality: 'Zakopane', hs: 140);
    final sapporo = const Hill.empty(country: Country.emptyNone())
        .copyWith(locality: 'Sapporo', hs: 137);
    final vikersund = const Hill.empty(country: Country.emptyNone())
        .copyWith(locality: 'Vikersund', hs: 240);
    const individualRules =
        IndividualCompetitionRules(rounds: [], allowChangingGates: true);
    const teamRules = TeamCompetitionRules(rounds: [], allowChangingGates: true);

    test('converting', () {
      final highLevelCalendar = [
        CalendarMainCompetitionRecord(
          hill: sapporo,
          date: DateTime.now(),
          preset: const CalendarMainCompetitionRecordSetup(
            rules: individualRules,
            trainingsRules: [
              individualRules,
              individualRules,
            ],
            trialRoundRules: individualRules,
            qualificationsRules: individualRules,
            moveQualificationsBeforeTeamCompetition: false,
          ),
        ),
      ];
    });
  });
}
