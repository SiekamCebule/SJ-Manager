import 'package:equatable/equatable.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/standings.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';

abstract class KoRoundAdvancementDeterminingContext<E, S extends Standings> {
  const KoRoundAdvancementDeterminingContext({
    required this.eventSeries,
    required this.competition,
    required this.currentRound,
    required this.hill,
    required this.entities,
    required this.koStandings,
  });

  // TODO: final SimulationData simulationData;
  // TODO: final Season season;
  final EventSeries eventSeries;
  final Competition<E, S> competition;
  final S koStandings;
  final int currentRound;
  final Hill hill;
  final List<E> entities;
}

abstract class KoRoundAdvancementDeterminator<E,
        C extends KoRoundAdvancementDeterminingContext<E, dynamic>>
    with EquatableMixin
    implements UnaryAlgorithm<KoRoundAdvancementDeterminingContext<E, dynamic>, List<E>> {
  const KoRoundAdvancementDeterminator();

  @override
  List<Object?> get props => [
        runtimeType,
      ];
}
