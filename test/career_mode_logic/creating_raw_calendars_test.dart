import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/models/db/event_series/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/db/event_series/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/db/event_series/competition/calendar_records/calendar_main_competition_records_to_calendar.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';
import 'package:sj_manager/models/db/event_series/competition/competition_type.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/individual_competition_rules.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/team_competition_rules.dart';
import 'package:sj_manager/models/db/hill/hill.dart';

void main() {
  group(CalendarMainCompetitionRecordsToCalendarConverter, () {
    final zakopane = const Hill.empty(country: Country.emptyNone())
        .copyWith(locality: 'Zakopane', hs: 140);
    final sapporo = const Hill.empty(country: Country.emptyNone())
        .copyWith(locality: 'Sapporo', hs: 137);
    final vikersund = const Hill.empty(country: Country.emptyNone())
        .copyWith(locality: 'Vikersund', hs: 240);
    const ind = IndividualCompetitionRules(
      rounds: [],
      allowChangingGates: false,
    );
    const team = TeamCompetitionRules(
      jumpersCountInTeam: 4,
      rounds: [],
      allowChangingGates: true,
    );

    const week = Duration(days: 7);
    const day = Duration(days: 1);

    test('Converting a high-level to the low-level calendar', () {
      final startDate = DateTime(2022, 1, 15);

      final highLevelCalendar = [
        CalendarMainCompetitionRecord(
          hill: sapporo,
          date: startDate,
          setup: const CalendarMainCompetitionRecordSetup(
            mainCompRules: ind,
            trainingsRules: [
              ind,
              ind,
            ],
            trialRoundRules: ind,
            qualificationsRules: ind,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: sapporo,
          date: startDate.add(day),
          setup: const CalendarMainCompetitionRecordSetup(
            mainCompRules: team,
            trialRoundRules: ind,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: zakopane,
          date: startDate.add(week),
          setup: const CalendarMainCompetitionRecordSetup(
            mainCompRules: team,
            trialRoundRules: ind,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: zakopane,
          date: startDate.add(week + day),
          setup: const CalendarMainCompetitionRecordSetup(
            mainCompRules: ind,
            trainingsRules: [
              ind,
              ind,
            ],
            trialRoundRules: ind,
            qualificationsRules: ind,
            moveQualificationsBeforeTeamCompetition: true,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: vikersund,
          date: startDate.add(week * 2),
          setup: const CalendarMainCompetitionRecordSetup(
            mainCompRules: team,
            trainingsRules: [
              ind,
            ],
            trialRoundRules: ind,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: vikersund,
          date: startDate.add(week * 2 + day * 2),
          setup: const CalendarMainCompetitionRecordSetup(
            mainCompRules: ind,
            trialRoundRules: ind,
            trainingsRules: [
              ind,
            ],
            qualificationsRules: ind,
          ),
        ),
      ];
      final lowLevelCalendar =
          CalendarMainCompetitionRecordsToCalendarConverter().convert(highLevelCalendar);
      expect(
        lowLevelCalendar,
        [
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 14),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 14),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 14),
            rules: ind,
            type: CompetitionType.qualifications,
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 15),
            rules: ind,
            type: CompetitionType.trialRound,
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 15),
            rules: ind,
            type: CompetitionType.competition, // są kwalifikacje w zakopanem
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 16),
            rules: ind,
            type: CompetitionType.trialRound,
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 16),
            rules: team,
            type: CompetitionType.competition,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 21),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 21),
            type: CompetitionType.training,
            rules: ind,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 21),
            type: CompetitionType.qualifications,
            rules: ind,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 22),
            rules: ind,
            type: CompetitionType.trialRound,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 22),
            rules: team,
            type: CompetitionType.competition,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 23),
            type: CompetitionType.trialRound,
            rules: ind,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 23),
            type: CompetitionType.competition,
            rules: ind,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 28),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 29),
            type: CompetitionType.trialRound,
            rules: ind,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 29),
            type: CompetitionType.competition,
            rules: team,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 30),
            type: CompetitionType.training,
            rules: ind,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 30),
            type: CompetitionType.qualifications,
            rules: ind,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 31),
            type: CompetitionType.trialRound,
            rules: ind,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 31),
            rules: ind,
            type: CompetitionType.competition,
          ),
        ].map((comp) => comp as Competition).toList(),
      );
    });

    test(
        'Should not move any competition (ind. comp does not have trial round, and it cannot be alone, so qualifications will not move)',
        () {
      final startDate = DateTime(2022, 6, 1);
      final highLevelCalendar = [
        CalendarMainCompetitionRecord(
          hill: vikersund,
          date: startDate,
          setup: const CalendarMainCompetitionRecordSetup(
            mainCompRules: team,
            trialRoundRules: ind,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: vikersund,
          date: startDate.add(day),
          setup: const CalendarMainCompetitionRecordSetup(
            qualificationsRules: ind,
            mainCompRules: ind,
          ),
        ),
      ];
      final lowLevelCalendar =
          CalendarMainCompetitionRecordsToCalendarConverter().convert(highLevelCalendar);
      expect(
        lowLevelCalendar,
        [
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 1),
            rules: ind,
            type: CompetitionType.trialRound,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 1),
            rules: team,
            type: CompetitionType.competition,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 2),
            rules: ind,
            type: CompetitionType.qualifications,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 2),
            rules: ind,
            type: CompetitionType.competition,
          ),
        ],
      );
    });

    test('Should move the qualifications to the beginning', () {
      final startDate = DateTime(2022, 6, 1);
      final highLevelCalendar = [
        CalendarMainCompetitionRecord(
          hill: vikersund,
          date: startDate,
          setup: const CalendarMainCompetitionRecordSetup(
            mainCompRules: team,
            trialRoundRules: ind,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: vikersund,
          date: startDate.add(day),
          setup: const CalendarMainCompetitionRecordSetup(
            qualificationsRules: ind,
            trialRoundRules: ind,
            mainCompRules: ind,
            moveQualificationsBeforeTeamCompetition: true,
          ),
        ),
      ];
      final lowLevelCalendar =
          CalendarMainCompetitionRecordsToCalendarConverter().convert(highLevelCalendar);
      expect(lowLevelCalendar, [
        Competition(
          hill: vikersund,
          date: DateTime(2022, 5, 31),
          rules: ind,
          type: CompetitionType.qualifications,
        ),
        Competition(
          hill: vikersund,
          date: DateTime(2022, 6, 1),
          rules: ind,
          type: CompetitionType.trialRound,
        ),
        Competition(
          hill: vikersund,
          date: DateTime(2022, 6, 1),
          rules: team,
          type: CompetitionType.competition,
        ),
        Competition(
          hill: vikersund,
          date: DateTime(2022, 6, 2),
          rules: ind,
          type: CompetitionType.trialRound,
        ),
        Competition(
          hill: vikersund,
          date: DateTime(2022, 6, 2),
          rules: ind,
          type: CompetitionType.competition,
        ),
      ]);
    });

    test(
        'The limit of 3 trainings in a day (example of a few pseudo days of world championships)',
        () {
      final startDate = DateTime(2022, 6, 1);
      final highLevelCalendar = [
        CalendarMainCompetitionRecord(
          hill: zakopane,
          date: startDate,
          setup: CalendarMainCompetitionRecordSetup(
            qualificationsRules: ind,
            trialRoundRules: ind,
            trainingsRules: List.generate(
              7,
              (_) => ind,
            ), // One of the trainings is instead of the trial round (cannot have two trial rounds)
            mainCompRules: ind,
          ),
        ),
      ];
      final lowLevelCalendar =
          CalendarMainCompetitionRecordsToCalendarConverter().convert(highLevelCalendar);
      expect(
        lowLevelCalendar,
        [
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 29),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 29),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 30),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 30),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 30),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 31),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 31),
            rules: ind,
            type: CompetitionType.training,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 31),
            rules: ind,
            type: CompetitionType.qualifications,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 6, 1),
            rules: ind,
            type: CompetitionType.trialRound,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 6, 1),
            rules: ind,
            type: CompetitionType.competition,
          ),
        ],
      );
    });
  });
}
