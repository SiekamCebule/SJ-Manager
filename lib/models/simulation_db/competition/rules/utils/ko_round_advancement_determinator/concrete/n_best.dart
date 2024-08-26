import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';

class NBestKoRoundAdvancementDeterminator<E> extends KoRoundAdvancementDeterminator<E,
    KoRoundNBestAdvancementDeterminingContext<E>> {
  const NBestKoRoundAdvancementDeterminator();

  @override
  List<E> compute(covariant KoRoundNBestAdvancementDeterminingContext<E> context) {
    final limit = context.limit;
    if (limit == null) {
      throw StateError('The EntitiesLimit is set to null, but it must be initialized');
    }
    final orderedEntities = context.koStandings.scores
        .map((score) => score.entity)
        .where((entity) => context.entities.contains(entity))
        .toList();
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

  final EntitiesLimit? limit;
}
