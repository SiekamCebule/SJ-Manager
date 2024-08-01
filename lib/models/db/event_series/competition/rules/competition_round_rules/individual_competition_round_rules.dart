import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';

class IndividualCompetitionRoundRules extends CompetitionRoundRules<Jumper> {
  const IndividualCompetitionRoundRules({
    required super.limit,
    required super.bibsAreReassigned,
    required super.gateCanChange,
    required super.windAverager,
    required super.inrunLightsEnabled,
    required super.dsqEnabled,
    required super.positionsCreator,
    required super.canBeCancelledByWind,
    required super.ruleOf95HsFallEnabled,
    required super.judgesCount,
    required super.competitionScoreCreator,
    required super.jumpScoreCreator,
    required super.significantJudgesChooser,
  });

  @override
  List<Object?> get props => [
        ...super.props,
      ];
}
