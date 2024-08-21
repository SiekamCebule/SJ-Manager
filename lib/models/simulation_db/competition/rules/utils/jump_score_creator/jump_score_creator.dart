import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/user_algorithms/entity_related_algorithm_context.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';

class JumpScoreCreatingContext extends EntityRelatedAlgorithmContext {
  const JumpScoreCreatingContext(
      {required super.entity,
      required this.eventSeries,
      required this.competition,
      required this.currentRound,
      required this.currentGroup,
      required this.hill,
      required this.initialGate,
      required this.gate,
      required this.windDuringJump,
      required this.averagedWind,
      required this.jumpRecord,
      required this.judges});

  // TODO: final SimulationData simulationData;
  // TODO: final Season season;
  final EventSeries eventSeries;
  final Competition competition;
  final int currentRound;
  final int? currentGroup;
  final Hill hill;
  final int initialGate;
  final int gate;
  final WindMeasurement windDuringJump;
  final Wind averagedWind;
  final JumpSimulationRecord jumpRecord;
  final List<double> judges;
}

abstract class JumpScoreCreator
    implements UnaryAlgorithm<JumpScoreCreatingContext, SingleJumpScore> {}
