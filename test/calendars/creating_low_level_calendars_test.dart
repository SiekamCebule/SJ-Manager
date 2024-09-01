import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_records_to_calendar.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/competition_labels.dart';
import 'package:sj_manager/models/simulation_db/competition/high_level_calendar.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';

import 'creating_low_level_calendars_test.mocks.dart';

@GenerateMocks([DefaultCompetitionRules])
void main() {
  group(CalendarMainCompetitionRecordsToCalendarConverter, () {
    final zakopane = const Hill.empty(country: Country.emptyNone())
        .copyWith(locality: 'Zakopane', hs: 140);
    final sapporo = const Hill.empty(country: Country.emptyNone())
        .copyWith(locality: 'Sapporo', hs: 137);
    final vikersund = const Hill.empty(country: Country.emptyNone())
        .copyWith(locality: 'Vikersund', hs: 240);
    final ind = MockDefaultCompetitionRules<Jumper>();
    final team = MockDefaultCompetitionRules<CompetitionTeam>();

    const week = Duration(days: 7);
    const day = Duration(days: 1);

    test('Converting a high-level to the low-level calendar', () {
      final startDate = DateTime(2022, 1, 15);

      final highLevelComps = [
        CalendarMainCompetitionRecord(
          hill: sapporo,
          date: startDate,
          setup: CalendarMainCompetitionRecordSetup(
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
          setup: CalendarMainCompetitionRecordSetup(
            mainCompRules: team,
            trialRoundRules: ind,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: zakopane,
          date: startDate.add(week),
          setup: CalendarMainCompetitionRecordSetup(
            mainCompRules: team,
            trialRoundRules: ind,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: zakopane,
          date: startDate.add(week + day),
          setup: CalendarMainCompetitionRecordSetup(
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
          setup: CalendarMainCompetitionRecordSetup(
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
          setup: CalendarMainCompetitionRecordSetup(
            mainCompRules: ind,
            trialRoundRules: ind,
            trainingsRules: [
              ind,
            ],
            qualificationsRules: ind,
          ),
        ),
      ];
      final highLevelCalendar = HighLevelCalendar(
        highLevelCompetitions: highLevelComps,
        classifications: [],
      );
      final lowLevelCalendar =
          CalendarMainCompetitionRecordsToCalendarConverter().convert(highLevelCalendar);
      expect(
        lowLevelCalendar.competitions,
        [
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 14),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 14),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 14),
            rules: ind,
            labels: [CompetitionType.qualifications],
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 15),
            rules: ind,
            labels: [CompetitionType.trialRound],
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 15),
            rules: ind,
            labels: [CompetitionType.competition], // są kwalifikacje w zakopanem
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 16),
            rules: ind,
            labels: [CompetitionType.trialRound],
          ),
          Competition(
            hill: sapporo,
            date: DateTime(2022, 1, 16),
            rules: team,
            labels: [CompetitionType.competition],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 21),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 21),
            labels: [CompetitionType.training],
            rules: ind,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 21),
            labels: [CompetitionType.qualifications],
            rules: ind,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 22),
            rules: ind,
            labels: [CompetitionType.trialRound],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 22),
            rules: team,
            labels: [CompetitionType.competition],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 23),
            labels: [CompetitionType.trialRound],
            rules: ind,
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 1, 23),
            labels: [CompetitionType.competition],
            rules: ind,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 28),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 29),
            labels: [CompetitionType.trialRound],
            rules: ind,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 29),
            labels: [CompetitionType.competition],
            rules: team,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 30),
            labels: [CompetitionType.training],
            rules: ind,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 30),
            labels: [CompetitionType.qualifications],
            rules: ind,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 31),
            labels: [CompetitionType.trialRound],
            rules: ind,
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 1, 31),
            rules: ind,
            labels: [CompetitionType.competition],
          ),
        ].map((comp) => comp as Competition).toList(),
      );
    });

    test(
        'Should not move any competition (ind. comp does not have trial round, and it cannot be alone, so qualifications will not move)',
        () {
      final startDate = DateTime(2022, 6, 1);
      final highLevelComps = [
        CalendarMainCompetitionRecord(
          hill: vikersund,
          date: startDate,
          setup: CalendarMainCompetitionRecordSetup(
            mainCompRules: team,
            trialRoundRules: ind,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: vikersund,
          date: startDate.add(day),
          setup: CalendarMainCompetitionRecordSetup(
            qualificationsRules: ind,
            mainCompRules: ind,
          ),
        ),
      ];
      final highLevelCalendar = HighLevelCalendar(
        highLevelCompetitions: highLevelComps,
        classifications: [],
      );
      final lowLevelCalendar =
          CalendarMainCompetitionRecordsToCalendarConverter().convert(highLevelCalendar);
      expect(
        lowLevelCalendar.competitions,
        [
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 1),
            rules: ind,
            labels: [CompetitionType.trialRound],
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 1),
            rules: team,
            labels: [CompetitionType.competition],
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 2),
            rules: ind,
            labels: [CompetitionType.qualifications],
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 2),
            rules: ind,
            labels: [CompetitionType.competition],
          ),
        ],
      );
    });

    test('Should move the qualifications to the beginning', () {
      final startDate = DateTime(2022, 6, 1);
      final highLevelComps = [
        CalendarMainCompetitionRecord(
          hill: vikersund,
          date: startDate,
          setup: CalendarMainCompetitionRecordSetup(
            mainCompRules: team,
            trialRoundRules: ind,
          ),
        ),
        CalendarMainCompetitionRecord(
          hill: vikersund,
          date: startDate.add(day),
          setup: CalendarMainCompetitionRecordSetup(
            qualificationsRules: ind,
            trialRoundRules: ind,
            mainCompRules: ind,
            moveQualificationsBeforeTeamCompetition: true,
          ),
        ),
      ];
      final highLevelCalendar = HighLevelCalendar(
        highLevelCompetitions: highLevelComps,
        classifications: [],
      );
      final lowLevelCalendar =
          CalendarMainCompetitionRecordsToCalendarConverter().convert(highLevelCalendar);
      expect(
        lowLevelCalendar.competitions,
        [
          Competition(
            hill: vikersund,
            date: DateTime(2022, 5, 31),
            rules: ind,
            labels: [CompetitionType.qualifications],
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 1),
            rules: ind,
            labels: [CompetitionType.trialRound],
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 1),
            rules: team,
            labels: [CompetitionType.competition],
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 2),
            rules: ind,
            labels: [CompetitionType.trialRound],
          ),
          Competition(
            hill: vikersund,
            date: DateTime(2022, 6, 2),
            rules: ind,
            labels: [CompetitionType.competition],
          ),
        ],
      );
    });

    test(
        'The limit of 3 trainings in a day (example of a few pseudo days of world championships)',
        () {
      final startDate = DateTime(2022, 6, 1);
      final highLevelComps = [
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
      final highLevelCalendar = HighLevelCalendar(
        highLevelCompetitions: highLevelComps,
        classifications: [],
      );
      final lowLevelCalendar =
          CalendarMainCompetitionRecordsToCalendarConverter().convert(highLevelCalendar);
      expect(
        lowLevelCalendar.competitions,
        [
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 29),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 29),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 30),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 30),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 30),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 31),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 31),
            rules: ind,
            labels: [CompetitionType.training],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 5, 31),
            rules: ind,
            labels: [CompetitionType.qualifications],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 6, 1),
            rules: ind,
            labels: [CompetitionType.trialRound],
          ),
          Competition(
            hill: zakopane,
            date: DateTime(2022, 6, 1),
            rules: ind,
            labels: [CompetitionType.competition],
          ),
        ],
      );
    });
  });
}
