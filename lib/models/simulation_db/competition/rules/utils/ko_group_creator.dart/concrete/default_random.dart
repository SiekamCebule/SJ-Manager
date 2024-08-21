import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default_customizable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/utils/iterable.dart';

class DefaultRandomKoGroupsCreator<E>
    extends DefaultCustomizableKoGroupsCreator<E, RandomKoGroupsCreatingContext<E>> {
  @override
  void constructGroupsAndRemainingEntities() {
    for (var entity in context.entities) {
      if (everyGroupAreFull) {
        remainingEntities.add(entity);
      } else {
        final randomKoGroup = nonFullGroups.randomElement();
        randomKoGroup.entities.add(entity);
      }
    }
  }
}
