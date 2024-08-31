import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_group.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';

abstract class KoGroupsCreatingContext<T> {
  const KoGroupsCreatingContext({
    required this.eventSeries,
    required this.competition,
    required this.currentRound,
    required this.hill,
  });

  // TODO: final SimulationData simulationData;
  // TODO: final Season season;
  final EventSeries eventSeries;
  final Competition<T, dynamic> competition;
  final int currentRound;
  final Hill hill;

  int get entitiesCount;
}

abstract class KoGroupsCustomizableCreatingContext<T> extends KoGroupsCreatingContext<T> {
  const KoGroupsCustomizableCreatingContext({
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
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.entitiesInGroup,
    required super.remainingEntitiesAction,
    required this.pots,
    required this.remainingEntities,
  });

  final List<List<T>> pots;
  final List<T> remainingEntities;

  @override
  int get entitiesCount {
    final inPots = pots.fold<int>(0, (sum, pot) => sum + pot.length);
    return inPots + remainingEntities.length;
  }
}

abstract class KoGroupsCreator<E, C extends KoGroupsCreatingContext<E>>
    with EquatableMixin
    implements UnaryAlgorithm<C, List<KoGroup<E>>> {
  const KoGroupsCreator();
}
