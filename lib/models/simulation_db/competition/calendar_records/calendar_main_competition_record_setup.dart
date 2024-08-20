import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';

class CalendarMainCompetitionRecordSetup with EquatableMixin {
  const CalendarMainCompetitionRecordSetup({
    required this.mainCompRules,
    this.trainingsRules,
    this.trialRoundRules,
    this.qualificationsRules,
    this.moveQualificationsBeforeTeamCompetition = false,
  }) : assert(
          !(moveQualificationsBeforeTeamCompetition == true && trialRoundRules == null),
        );

  final DefaultCompetitionRules mainCompRules;
  final List<DefaultCompetitionRules>? trainingsRules;
  final DefaultCompetitionRules? trialRoundRules;
  final DefaultCompetitionRules? qualificationsRules;
  final bool moveQualificationsBeforeTeamCompetition;

  @override
  List<Object?> get props => [
        trainingsRules,
        trialRoundRules,
        qualificationsRules,
        moveQualificationsBeforeTeamCompetition,
      ];
}
