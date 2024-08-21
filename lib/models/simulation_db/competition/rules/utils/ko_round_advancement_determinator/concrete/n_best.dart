import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';

class NBestKoRoundAdvancementDeterminator<E> extends KoRoundAdvancementDeterminator<E,
    KoRoundNBestAdvancementDeterminingContext<E>> {
  @override
  List<E> compute(covariant KoRoundNBestAdvancementDeterminingContext<E> context) {
    final orderedEntities = context.koStandings.scores
        .map((score) => score.entity)
        .where((entity) => context.entities.contains(entity))
        .toList();
    final areInLimit = orderedEntities
        .where(
          (entity) => context.koStandings.positionOf(entity) <= context.limit.count,
        )
        .toList();
    if (context.limit.type == EntitiesLimitType.soft) {
      return areInLimit;
    } else {
      areInLimit.length = context.limit.count;
      return areInLimit;
    }
  }
}
