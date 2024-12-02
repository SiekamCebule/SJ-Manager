import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';

class KoRoundRules<T> with EquatableMixin {
  const KoRoundRules({
    required this.advancementDeterminator,
    required this.advancementCount,
    required this.koGroupsCreator,
    required this.groupSize,
  });

  final KoRoundAdvancementDeterminator<T> advancementDeterminator;
  final int advancementCount;
  final KoGroupsCreator<T> koGroupsCreator;
  final int groupSize;

  @override
  List<Object?> get props => [
        advancementDeterminator,
        advancementCount,
        koGroupsCreator,
        groupSize,
      ];
}
