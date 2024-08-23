import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';

class KoRoundRules<E> with EquatableMixin {
  const KoRoundRules({
    required this.advancementDeterminator,
    required this.koGroupsCreator,
  });

  final KoRoundAdvancementDeterminator<E, KoRoundAdvancementDeterminingContext<E>>
      advancementDeterminator;
  final KoGroupsCreator<E, KoGroupsCreatingContext<E>> koGroupsCreator;

  @override
  List<Object?> get props => [];
}
