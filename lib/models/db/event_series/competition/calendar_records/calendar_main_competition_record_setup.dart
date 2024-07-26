import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';

class CalendarMainCompetitionRecordSetup<T> with EquatableMixin {
  const CalendarMainCompetitionRecordSetup({
    required this.rules,
    required this.trainingsRules,
    required this.trialRoundRules,
    required this.qualificationsRules,
    required this.moveQualificationsBeforeTeamCompetition,
  });

  final CompetitionRules<T> rules;
  final List<CompetitionRules<T>> trainingsRules;
  final CompetitionRules<T>? trialRoundRules;
  final CompetitionRules<T>? qualificationsRules;
  final bool moveQualificationsBeforeTeamCompetition;

  @override
  List<Object?> get props => [
        trainingsRules,
        trialRoundRules,
        qualificationsRules,
        moveQualificationsBeforeTeamCompetition,
      ];
}
