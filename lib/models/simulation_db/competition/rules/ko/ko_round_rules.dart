import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';

class KoRoundRules<E> with EquatableMixin {
  const KoRoundRules({
    required this.advancementDeterminator,
    required this.advancementCount,
    required this.koGroupsCreator,
    required this.groupSize,
  });

  final KoRoundAdvancementDeterminator<E, KoRoundAdvancementDeterminingContext<E>>
      advancementDeterminator;
  final int advancementCount;
  final KoGroupsCreator<E, KoGroupsCreatingContext<E>> koGroupsCreator;
  final int groupSize;

  @override
  List<Object?> get props => [
        advancementDeterminator,
        advancementCount,
        koGroupsCreator,
        groupSize,
      ];
}
