import 'package:equatable/equatable.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/entities_limit.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/wind_averager/wind_averager.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/score.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings_positions_map_creator/standings_positions_creator.dart';

abstract class DefaultCompetitionRoundRules<T> with EquatableMixin {
  const DefaultCompetitionRoundRules({
    required this.limit,
    required this.bibsAreReassigned,
    required this.startlistIsSorted,
    required this.gateCanChange,
    required this.gateCompensationsEnabled,
    required this.windCompensationsEnabled,
    required this.windAverager,
    required this.inrunLightsEnabled,
    required this.dsqEnabled,
    required this.positionsCreator,
    required this.ruleOf95HsFallEnabled,
    required this.judgesCount,
    required this.judgesCreator,
    required this.significantJudgesCount,
    required this.jumpScoreCreator,
    required this.competitionScoreCreator,
    required this.koRules,
  });

  final EntitiesLimit? limit;
  final bool bibsAreReassigned;
  final bool startlistIsSorted;
  final bool gateCanChange;
  final bool gateCompensationsEnabled;
  final bool windCompensationsEnabled;
  final WindAverager? windAverager;
  final bool inrunLightsEnabled;
  final bool dsqEnabled;
  final StandingsPositionsCreator positionsCreator;
  final bool ruleOf95HsFallEnabled;
  final int judgesCount;
  final JudgesCreator judgesCreator;
  final int significantJudgesCount;
  final JumpScoreCreator jumpScoreCreator;
  final CompetitionScoreCreator<Score<T, CompetitionScoreDetails>>
      competitionScoreCreator;
  final KoRoundRules? koRules;

  bool get judgesEnabled => judgesCount > 0;

  @override
  List<Object?> get props => [
        limit,
        bibsAreReassigned,
        startlistIsSorted,
        gateCanChange,
        gateCompensationsEnabled,
        windCompensationsEnabled,
        windAverager,
        inrunLightsEnabled,
        dsqEnabled,
        positionsCreator,
        ruleOf95HsFallEnabled,
        judgesCount,
        judgesCreator,
        significantJudgesCount,
        jumpScoreCreator,
        competitionScoreCreator,
        koRules,
      ];
}
