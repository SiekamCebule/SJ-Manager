import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';

abstract class KoGroupsCreatingContext<T> {
  const KoGroupsCreatingContext({
    required this.simulationDatabase,
    required this.season,
    required this.eventSeries,
    required this.competition,
    required this.currentRound,
    required this.hill,
  });

  final SimulationDatabase simulationDatabase;
  final SimulationSeason season;
  final EventSeries eventSeries;
  final Competition<T> competition;
  final int currentRound;
  final Hill hill;

  int get entitiesCount;
}

abstract class KoGroupsCustomizableCreatingContext<T> extends KoGroupsCreatingContext<T> {
  const KoGroupsCustomizableCreatingContext({
    required super.simulationDatabase,
    required super.season,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required this.entitiesInGroup,
    required this.remainingEntitiesAction,
  });

  final int entitiesInGroup;
  final KoGroupsCreatorRemainingEntitiesAction remainingEntitiesAction;
}

class RandomKoGroupsCreatingContext<T> extends KoGroupsCustomizableCreatingContext<T> {
  const RandomKoGroupsCreatingContext({
    required super.simulationDatabase,
    required super.season,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.entitiesInGroup,
    required super.remainingEntitiesAction,
    required this.entities,
  });

  final List<T> entities;

  @override
  int get entitiesCount => entities.length;
}

class ClassicKoGroupsCreatingContext<T> extends KoGroupsCreatingContext<T> {
  const ClassicKoGroupsCreatingContext({
    required super.simulationDatabase,
    required super.season,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required this.entities,
  });

  final List<T> entities;

  @override
  int get entitiesCount => entities.length;
}

class KoGroupsPotsCreatingContext<T> extends KoGroupsCustomizableCreatingContext<T> {
  const KoGroupsPotsCreatingContext({
    required super.simulationDatabase,
    required super.season,
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.entitiesInGroup,
    required super.remainingEntitiesAction,
    required this.pots,
  });

  final List<List<T>> pots;

  @override
  int get entitiesCount {
    return pots.fold<int>(0, (sum, pot) => sum + pot.length);
  }
}
