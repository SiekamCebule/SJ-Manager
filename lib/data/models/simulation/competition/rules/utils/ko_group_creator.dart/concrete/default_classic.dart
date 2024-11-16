import 'package:sj_manager/data/models/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';

class DefaultClassicKoGroupsCreator<E>
    extends DefaultSizedKoGroupsCreator<E, ClassicKoGroupsCreatingContext<E>> {
  @override
  void validateData() {
    if (entitiesInGroup.remainder(2) != 0) {
      throw ArgumentError(
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

    for (var group in groups) {
      if (startIndex >= 0 && endIndex < context.entities.length) {
        group.entities.add(context.entities[endIndex]);
        group.entities.add(context.entities[startIndex]);
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

  @override
  List<Object?> get props => [runtimeType];
}
