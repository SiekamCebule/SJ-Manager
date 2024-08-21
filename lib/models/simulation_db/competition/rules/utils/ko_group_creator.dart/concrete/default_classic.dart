import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';

class DefaultClassicKoGroupsCreator<E>
    extends DefaultSizedKoGroupsCreator<E, ClassicKoGroupsCreatingContext<E>> {
  @override
  void validateData() {
    if (entitiesInGroup.remainder(2) != 0) {
      throw StateError(
        'In DefaultClassicKoGroupsCreator, the entities count must be dividable by 2.',
      );
    }
    super.validateData();
  }

  @override
  void constructGroupsAndRemainingEntities() {
    int middle = context.entities.length ~/ 2;
    int startIndex = middle - 1;
    int endIndex = middle;

    for (var group in koGroups) {
      if (startIndex >= 0 && endIndex < context.entities.length) {
        group.entities.add(context.entities[startIndex]);
        group.entities.add(context.entities[endIndex]);
      }
      startIndex--;
      endIndex++;
    }
  }

  @override
  KoGroupsCreatorRemainingEntitiesAction get remainingEntitiesAction =>
      KoGroupsCreatorRemainingEntitiesAction.throwError;

  @override
  int get entitiesInGroup => 2;
}
