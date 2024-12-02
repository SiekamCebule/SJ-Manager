import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/context/ko_groups_creator_context.dart';
import 'package:sj_manager/to_embrace/competition/rules/ko/ko_group.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/concrete/default_customizable.dart';
import 'package:sj_manager/core/general_utils/iterable.dart';

class DefaultRandomKoGroupsCreator<T> extends DefaultCustomizableKoGroupsCreator<T> {
  @override
  RandomKoGroupsCreatingContext<T> getContext() =>
      context as RandomKoGroupsCreatingContext<T>;
  @override
  void constructGroupsAndRemainingEntities() {
    for (var entity in getContext().entities) {
      if (everyGroupIsFull) {
        remainingEntities.add(entity);
      } else {
        late KoGroup<T> targetGroup;
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
