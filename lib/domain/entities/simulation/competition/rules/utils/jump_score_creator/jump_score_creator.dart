import 'package:equatable/equatable.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/domain/entities/simulation/competition/competition.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/general/entity_related_algorithm_context.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/score.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/hill.dart';

class JumpScoreCreatingContext<E> extends EntityRelatedAlgorithmContext<E> {
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
  final double averagedWind;
  final JumpSimulationRecord jumpRecord;
  final List<double> judges;
}

abstract class JumpScoreCreator<E>
    with
        EquatableMixin
    implements
        UnaryAlgorithm<JumpScoreCreatingContext<E>,
            Score<E, CompetitionJumpScoreDetails>> {
  const JumpScoreCreator();

  @override
  List<Object?> get props => [
        runtimeType,
      ];
}
