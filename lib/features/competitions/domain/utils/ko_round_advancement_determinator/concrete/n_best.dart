import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/context/ko_round_advancemenent_determinating_context.dart';
import 'package:sj_manager/to_embrace/competition/rules/entities_limit.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';

class NBestKoRoundAdvancementDeterminator<T> extends KoRoundAdvancementDeterminator<T> {
  const NBestKoRoundAdvancementDeterminator();

  @override
  List<T> determineAdvancement(
      covariant KoRoundNBestAdvancementDeterminingContext<T> context) {
    final limit = context.limit;
    if (limit == null) {
      return context.entities;
    }

    final orderedEntities = context.koStandings.scores
        .map((score) => score.subject)
        .where((entity) => context.entities.contains(entity))
        .toList()
        .cast<T>();

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
