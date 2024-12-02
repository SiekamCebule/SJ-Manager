import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';

abstract class JudgesCreatingContext {
  const JudgesCreatingContext({
    required this.simulationDatabase,
    required this.season,
    required this.eventSeries,
    required this.competition,
    required this.currentRound,
    required this.hill,
    required this.windMeasurement,
    required this.jumpSimulationRecord,
    required this.judgesCount,
  });

  final SimulationDatabase simulationDatabase;
  final SimulationSeason season;
  final EventSeries eventSeries;
  final Competition competition;
  final int currentRound;
  final Hill hill;
  final WindMeasurement windMeasurement;
  final JumpSimulationRecord jumpSimulationRecord;
  final int judgesCount;
}
