import 'package:equatable/equatable.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/compensation_calculators/gate/gate_compensation_calculator.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/compensation_calculators/wind/wind_compensation_calculator.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/db/event_series/standings/score/competition_scores.dart';
import 'package:sj_manager/models/db/event_series/standings/score/jump_score.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_creator.dart';

abstract class CompetitionRoundRules<T> with EquatableMixin {
  const CompetitionRoundRules({
    required this.limit,
    required this.bibsAreReassigned,
    required this.gateCanChange,
    required this.gateCompensationCalculator,
    required this.windCompensationCalculator,
    required this.inrunLightsEnabled,
    required this.dsqEnabled,
    required this.positionsCreator,
    required this.canBeCancelledByWind,
    required this.ruleOf95HsFallEnabled,
    required this.judgesCount,
    required this.chooseSignificantJudges,
    required this.createJumpScore,
    required this.createCompetitionScore,
  });

  final EntitiesLimit? limit;
  final bool bibsAreReassigned;
  final bool gateCanChange;
  final GateCompensationCalculator? gateCompensationCalculator;
  final WindCompensationCalculator? windCompensationCalculator;
  final bool inrunLightsEnabled;
  final bool dsqEnabled;
  final StandingsPositionsCreator positionsCreator;
  final bool canBeCancelledByWind;
  final bool ruleOf95HsFallEnabled;
  final int judgesCount;
  final Set<double> Function(Set<double> judges) chooseSignificantJudges;
  final JumpScore Function(JumpSimulationRecord jumpRecord) createJumpScore;
  final CompetitionScore Function(JumpSimulationRecord jumpScore) createCompetitionScore;

  @override
  List<Object?> get props => [
        limit,
        bibsAreReassigned,
        gateCanChange,
        gateCompensationCalculator,
        windCompensationCalculator,
        inrunLightsEnabled,
        dsqEnabled,
        positionsCreator,
        canBeCancelledByWind,
        ruleOf95HsFallEnabled,
        judgesCount.bitLength,
        chooseSignificantJudges,
        createJumpScore,
      ];
}
