import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_group.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default_customizable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/utils/iterable.dart';

class DefaultRandomKoGroupsCreator<E>
    extends DefaultCustomizableKoGroupsCreator<E, RandomKoGroupsCreatingContext<E>> {
  @override
  void constructGroupsAndRemainingEntities() {
    for (var entity in context.entities) {
      if (everyGroupIsFull) {
        remainingEntities.add(entity);
      } else {
        late KoGroup<E> targetGroup;
        if (nonFullGroups.length > 1) {
          int minSize = nonFullGroups
              .map((group) => group.entities.length)
              .reduce((a, b) => a < b ? a : b);
          var smallestGroups =
              nonFullGroups.where((group) => group.entities.length == minSize).toList();
          targetGroup = smallestGroups.randomElement();
        } else {
          targetGroup = nonFullGroups.single;
        }

        targetGroup.entities.add(entity);
      }
    }
  }

  @override
  List<Object?> get props => [runtimeType];
}
