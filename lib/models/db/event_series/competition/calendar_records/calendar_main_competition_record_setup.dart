import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';

class CalendarMainCompetitionRecordSetup with EquatableMixin {
  const CalendarMainCompetitionRecordSetup({
    required this.mainCompRules,
    this.trainingsRules,
    this.trialRoundRules,
    this.qualificationsRules,
    this.moveQualificationsBeforeTeamCompetition = false,
  }) : assert(
          !(moveQualificationsBeforeTeamCompetition == true &&
              trialRoundRules == null),
        );

  final CompetitionRules mainCompRules;
  final List<CompetitionRules>? trainingsRules;
  final CompetitionRules? trialRoundRules;
  final CompetitionRules? qualificationsRules;
  final bool moveQualificationsBeforeTeamCompetition;

  @override
  List<Object?> get props => [
        trainingsRules,
        trialRoundRules,
        qualificationsRules,
        moveQualificationsBeforeTeamCompetition,
      ];
}
