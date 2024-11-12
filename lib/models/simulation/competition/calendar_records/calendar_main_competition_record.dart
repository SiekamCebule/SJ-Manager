import 'package:sj_manager/models/simulation/competition/calendar_records/high_level_competition_record.dart';
import 'package:sj_manager/models/simulation/competition/calendar_records/calendar_main_competition_record_setup.dart';
import 'package:sj_manager/models/simulation/competition/competition.dart';
import 'package:sj_manager/models/simulation/competition/competition_labels.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/models/simulation/standings/standings.dart';
import 'package:sj_manager/models/database/hill/hill.dart';
import 'package:sj_manager/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/models/database/team/competition_team.dart';
import 'package:equatable/equatable.dart';

class CalendarMainCompetitionRecord
    with EquatableMixin
    implements HighLevelCompetitionRecord {
  const CalendarMainCompetitionRecord({
    required this.hill,
    required this.date,
    required this.setup,
  });

  final Hill hill;
  final DateTime? date;
  final CalendarMainCompetitionRecordSetup setup;

  @override
  List<Competition> createRawCompetitions() {
    return _Converter().convert(this);
  }

  @override
  List<Object?> get props => [hill, date, setup];
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
        date: record.date!,
        rules: rules,
        labels: const [DefaultCompetitionType.trialRound],
      );
    }

    final trainings = List.generate(record.setup.trainingsCount, (trainingIndex) {
      final daysSubtraction =
          trainingsDateBaseSubtraction + Duration(days: trainingIndex ~/ 3);
      return _competitionWithPreservedType(
        hill: record.hill,
        date: record.date!.subtract(daysSubtraction),
        rules: record.setup.trainingsRules!,
        labels: const [DefaultCompetitionType.training],
      );
    });

    Competition? quals;
    if (record.setup.qualificationsRules != null) {
      quals = _competitionWithPreservedType(
        hill: record.hill,
        date: record.date!.subtract(qualificationsDateSubtraction),
        rules: record.setup.qualificationsRules!,
        labels: const [DefaultCompetitionType.qualifications],
      );
    }

    final mainCompetition = _competitionWithPreservedType(
      hill: record.hill,
      date: record.date!,
      rules: record.setup.mainCompRules,
      labels: const [DefaultCompetitionType.competition],
    );

    final comps = [
      ...trainings,
      if (quals != null) quals,
      if (trialRound != null) trialRound,
      mainCompetition,
    ];

    return comps;
  }

  Competition<T, Standings> _competitionWithPreservedType<T>({
    required Hill hill,
    required DateTime date,
    required DefaultCompetitionRulesProvider<T> rules,
    List<Object> labels = const [],
  }) {
    if (rules is DefaultCompetitionRules<JumperDbRecord>) {
      return Competition<JumperDbRecord, Standings>(
        hill: hill,
        date: date,
        rules: rules as DefaultCompetitionRules<JumperDbRecord>,
        labels: labels,
      ) as Competition<T, Standings>;
    } else if (rules is DefaultCompetitionRules<CompetitionTeam>) {
      return Competition<CompetitionTeam, Standings>(
        hill: hill,
        date: date,
        rules: rules as DefaultCompetitionRules<CompetitionTeam>,
        labels: labels,
      ) as Competition<T, Standings>;
    } else {
      throw TypeError();
    }
  }
}
