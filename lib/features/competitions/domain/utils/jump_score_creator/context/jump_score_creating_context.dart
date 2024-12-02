import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';

class JumpScoreCreatingContext<T> {
  const JumpScoreCreatingContext({
    required this.subject,
    required this.simulationDatabase,
    required this.season,
    required this.eventSeries,
    required this.competition,
    required this.currentRound,
    required this.currentGroup,
    required this.hill,
    required this.initialGate,
    required this.gate,
    required this.windDuringJump,
    required this.averagedWind,
    required this.jump,
    required this.judges,
  });

  final T subject;
  final SimulationDatabase simulationDatabase;
  final SimulationSeason season;
  final EventSeries eventSeries;
  final Competition competition;
  final int currentRound;
  final int? currentGroup;
  final Hill hill;
  final int initialGate;
  final int gate;
  final WindMeasurement windDuringJump;
  final double averagedWind;
  final JumpSimulationRecord jump;
  final List<double> judges;
}
