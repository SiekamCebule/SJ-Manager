import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class DefaultIndividualCompetitionRoundRules
    extends DefaultCompetitionRoundRules<Jumper> {
  const DefaultIndividualCompetitionRoundRules({
    required super.limit,
    required super.bibsAreReassigned,
    required super.gateCanChange,
    required super.windAverager,
    required super.inrunLightsEnabled,
    required super.dsqEnabled,
    required super.positionsCreator,
    required super.ruleOf95HsFallEnabled,
    required super.judgesCount,
    required super.significantJudgesCount,
    required super.competitionScoreCreator,
    required super.jumpScoreCreator,
    required super.koRules,
  });

  @override
  List<Object?> get props => [
        ...super.props,
      ];
}
