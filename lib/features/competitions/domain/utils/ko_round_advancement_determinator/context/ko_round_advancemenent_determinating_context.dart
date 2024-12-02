import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/standings.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/rules/entities_limit.dart';

abstract class KoRoundAdvancementDeterminingContext<T> {
  const KoRoundAdvancementDeterminingContext({
    required this.simulationDatabase,
    required this.season,
    required this.eventSeries,
    required this.competition,
    required this.currentRound,
    required this.hill,
    required this.entities,
    required this.koStandings,
  });

  final SimulationDatabase simulationDatabase;
  final SimulationSeason season;
  final EventSeries eventSeries;
  final Competition<T> competition;
  final Standings koStandings;
  final int currentRound;
  final Hill hill;
  final List<T> entities;
}

class KoRoundNBestAdvancementDeterminingContext<T>
    extends KoRoundAdvancementDeterminingContext<T> {
  const KoRoundNBestAdvancementDeterminingContext({
    required super.simulationDatabase,
    required super.season,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.entities,
    required super.koStandings,
    required this.limit,
  });

  final EntitiesLimit? limit;
}
