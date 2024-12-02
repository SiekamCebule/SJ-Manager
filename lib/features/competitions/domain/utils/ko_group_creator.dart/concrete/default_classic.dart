import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/context/ko_groups_creator_context.dart';

class DefaultClassicKoGroupsCreator<T> extends DefaultSizedKoGroupsCreator<T> {
  @override
  ClassicKoGroupsCreatingContext<T> getContext() =>
      context as ClassicKoGroupsCreatingContext<T>;

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
    int middle = getContext().entities.length ~/ 2;
    int startIndex = middle - 1;
    int endIndex = middle;

    for (var group in groups) {
      if (startIndex >= 0 && endIndex < getContext().entities.length) {
        group.entities.add(getContext().entities[endIndex]);
        group.entities.add(getContext().entities[startIndex]);
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
