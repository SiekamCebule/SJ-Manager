import 'package:sj_manager/to_embrace/competition/rules/entities_limit.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/score_details.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/standings.dart';

class NBestKoRoundAdvancementDeterminator<E, S extends Standings<E, ScoreDetails>>
    extends KoRoundAdvancementDeterminator<E,
        KoRoundNBestAdvancementDeterminingContext<E, S>> {
  const NBestKoRoundAdvancementDeterminator();

  @override
  List<E> compute(covariant KoRoundNBestAdvancementDeterminingContext<E, S> context) {
    final limit = context.limit;
    if (limit == null) {
      return context.entities;
    }

    final orderedEntities = context.koStandings.scores
        .map((score) => score.entity)
        .where((entity) => context.entities.contains(entity))
        .toList();

    orderedEntities.shuffle();

    final areInLimit = orderedEntities
        .where(
          (entity) => context.koStandings.positionOf(entity)! <= limit.count,
        )
        .toList();

    if (limit.type == EntitiesLimitType.soft) {
      return areInLimit;
    } else {
      areInLimit.length = limit.count;
      return areInLimit;
    }
  }

  @override
  List<Object?> get props => [
        super.props,
      ];
}

class KoRoundNBestAdvancementDeterminingContext<T, S extends Standings>
    extends KoRoundAdvancementDeterminingContext<T, S> {
  const KoRoundNBestAdvancementDeterminingContext({
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
