import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';

abstract class KoRoundAdvancementDeterminingContext<T> {
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
  final Competition<T> competition;
  final Standings<T> koStandings;
  final int currentRound;
  final Hill hill;
  final List<T> entities;
}

class KoRoundNBestAdvancementDeterminingContext<T>
    extends KoRoundAdvancementDeterminingContext<T> {
  const KoRoundNBestAdvancementDeterminingContext({
    required super.eventSeries,
    required super.competition,
    required super.currentRound,
    required super.hill,
    required super.entities,
    required super.koStandings,
    required this.limit,
  });

  final EntitiesLimit limit;
}

abstract class KoRoundAdvancementDeterminator<E,
        C extends KoRoundAdvancementDeterminingContext<E>>
    implements UnaryAlgorithm<KoRoundAdvancementDeterminingContext<E>, List<E>> {}
