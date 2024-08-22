import 'package:sj_manager/models/simulation_db/competition/calendar_records/high_level_competition_record.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/competition_labels.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

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
        labels: const [CompetitionType.trialRound],
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
            labels: const [CompetitionType.training],
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
        labels: const [CompetitionType.qualifications],
      );
    }

    final mainCompetition = _competitionWithPreservedType(
      hill: record.hill,
      date: record.date,
      rules: record.setup.mainCompRules,
      labels: const [CompetitionType.competition],
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
    required DefaultCompetitionRules<T> rules,
    List<Object> labels = const [],
  }) {
    if (rules is DefaultCompetitionRules<Jumper>) {
      return Competition<Jumper>(
        hill: hill,
        date: date,
        rules: rules as DefaultCompetitionRules<Jumper>,
        labels: labels,
      ) as Competition<T>;
    } else if (rules is DefaultCompetitionRules<CompetitionTeam>) {
      return Competition<CompetitionTeam>(
        hill: hill,
        date: date,
        rules: rules as DefaultCompetitionRules<CompetitionTeam>,
        labels: labels,
      ) as Competition<T>;
    } else {
      throw TypeError();
    }
  }
}
