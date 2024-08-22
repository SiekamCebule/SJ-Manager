import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/utils/iterable.dart';

class DefaultPotsKoGroupsCreator<E>
    extends DefaultSizedKoGroupsCreator<E, KoGroupsPotsCreatingContext<E>> {
  @override
  void constructGroupsAndRemainingEntities() {
    final potsCount = entitiesInGroup;
    remainingEntities = context.remainingEntities;

    for (var potIndex = 0; potIndex < potsCount; potIndex++) {
      for (var entity in context.pots[potIndex]) {
        final randomGroup = groupsWithSize(potIndex).randomElement();
        randomGroup.entities.add(entity);
      }
    }
  }

  @override
  int get entitiesInGroup => context.entitiesInGroup;

  @override
  KoGroupsCreatorRemainingEntitiesAction get remainingEntitiesAction =>
      context.remainingEntitiesAction;
}

// Jak ustalić remainingEntities?
