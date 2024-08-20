import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/user_algorithms/concrete/competition_score_creator.dart';
import 'package:sj_manager/models/user_algorithms/concrete/jump_score_creator.dart';
import 'package:sj_manager/models/user_algorithms/concrete/significant_judges_chooser.dart';
import 'package:sj_manager/models/user_algorithms/concrete/wind_averager.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';

abstract class DefaultCompetitionRoundRules<T> with EquatableMixin {
  const DefaultCompetitionRoundRules({
    required this.limit,
    required this.bibsAreReassigned,
    required this.gateCanChange,
    required this.windAverager,
    required this.inrunLightsEnabled,
    required this.dsqEnabled,
    required this.positionsCreator,
    required this.canBeCancelledByWind,
    required this.ruleOf95HsFallEnabled,
    required this.judgesCount,
    required this.significantJudgesChooser,
    required this.jumpScoreCreator,
    required this.competitionScoreCreator,
  });

  final EntitiesLimit? limit;
  final bool bibsAreReassigned;
  final bool gateCanChange;
  final WindAverager? windAverager;
  final bool inrunLightsEnabled;
  final bool dsqEnabled;
  final StandingsPositionsCreator positionsCreator;
  final bool canBeCancelledByWind;
  final bool ruleOf95HsFallEnabled;
  final int judgesCount;
  final SignificantJudgesChooser significantJudgesChooser;
  final JumpScoreCreator jumpScoreCreator;
  final CompetitionScoreCreator competitionScoreCreator;

  @override
  List<Object?> get props => [
        limit,
        bibsAreReassigned,
        gateCanChange,
        windAverager,
        inrunLightsEnabled,
        dsqEnabled,
        positionsCreator,
        canBeCancelledByWind,
        ruleOf95HsFallEnabled,
        judgesCount.bitLength,
        significantJudgesChooser,
        jumpScoreCreator,
        competitionScoreCreator,
      ];
}
