import 'package:sj_manager/models/db/event_series/competition/calendar_records/high_level_competition_record.dart';
import 'package:sj_manager/models/db/event_series/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';
import 'package:sj_manager/models/db/event_series/competition/competition_type.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/models/db/team/team.dart';

class CalendarMainCompetitionRecord implements HighLevelCompetitionRecord {
  const CalendarMainCompetitionRecord({
    required this.hill,
    required this.date,
    required this.setup,
  });

  final Hill hill;
  final DateTime date;
  final CalendarMainCompetitionRecordSetup setup;

  @override
  List<Competition> createRawCompetitions() {
    return _Converter().convert(this);
  }
}

class _Converter {
  List<Competition> convert(CalendarMainCompetitionRecord record) {
    var trainingsDateBaseSubtraction = Duration.zero;
    var qualificationsDateSubtraction = Duration.zero;

    Competition? trialRound;
    if (record.setup.trialRoundRules != null) {
      trainingsDateBaseSubtraction += const Duration(days: 1);
      qualificationsDateSubtraction += const Duration(days: 1);
      final rules = record.setup.trialRoundRules!;
      trialRound = _competitionWithPreservedType(
        hill: record.hill,
        date: record.date,
        rules: rules,
        labels: const {CompetitionType.trialRound},
      );
    }

    int trainingIndex = 0;
    final trainings = record.setup.trainingsRules
        ?.map((rules) {
          trainingIndex++;
          final daysSubtraction =
              trainingsDateBaseSubtraction + Duration(days: trainingIndex ~/ 3);
          return _competitionWithPreservedType(
            hill: record.hill,
            date: record.date.subtract(daysSubtraction),
            rules: rules,
            labels: const {CompetitionType.training},
          );
        })
        .toList()
        .reversed;

    Competition? quals;
    if (record.setup.qualificationsRules != null) {
      quals = _competitionWithPreservedType(
        hill: record.hill,
        date: record.date.subtract(qualificationsDateSubtraction),
        rules: record.setup.qualificationsRules!,
        labels: const {CompetitionType.qualifications},
      );
    }

    final mainCompetition = _competitionWithPreservedType(
      hill: record.hill,
      date: record.date,
      rules: record.setup.mainCompRules,
      labels: const {CompetitionType.competition},
    );

    final comps = [
      if (trainings != null) ...trainings,
      if (quals != null) quals,
      if (trialRound != null) trialRound,
      mainCompetition,
    ];

    return comps;
  }

  Competition<T> _competitionWithPreservedType<T>({
    required Hill hill,
    required DateTime date,
    required CompetitionRules<T> rules,
    Set<Object> labels = const {},
  }) {
    if (rules is CompetitionRules<Jumper>) {
      return Competition<Jumper>(
        hill: hill,
        date: date,
        rules: rules as CompetitionRules<Jumper>,
        labels: labels,
      ) as Competition<T>;
    } else if (rules is CompetitionRules<Team>) {
      return Competition<Team>(
        hill: hill,
        date: date,
        rules: rules as CompetitionRules<Team>,
        labels: labels,
      ) as Competition<T>;
    } else {
      throw TypeError();
    }
  }
}
