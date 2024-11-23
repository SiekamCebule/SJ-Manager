import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/general/entity_related_algorithm_context.dart';
import 'package:sj_manager/to_embrace/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';

class WindAveragingContext extends EntityRelatedAlgorithmContext {
  const WindAveragingContext({
    required super.entity,
    required this.eventSeries,
    required this.competition,
    required this.currentRound,
    required this.currentGroup,
    required this.hill,
    required this.initialGate,
    required this.gate,
    required this.windMeasurement,
    this.windMeasurementWeights,
    required this.distance,
  });

  // TODO: final SimulationData simulationData;
  // TODO: final Season season;
  final EventSeries eventSeries;
  final Competition competition;
  final int currentRound;
  final int? currentGroup;
  final Hill hill;
  final int initialGate;
  final int gate;
  final WindMeasurement windMeasurement;
  final List<double>? windMeasurementWeights;
  final double distance;
}

abstract class WindAverager implements UnaryAlgorithm<WindAveragingContext, double> {
  const WindAverager();
}
