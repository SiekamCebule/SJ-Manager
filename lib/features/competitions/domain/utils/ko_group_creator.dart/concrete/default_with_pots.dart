import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/context/ko_groups_creator_context.dart';
import 'package:sj_manager/core/general_utils/iterable.dart';

class DefaultPotsKoGroupsCreator<T> extends DefaultSizedKoGroupsCreator<T> {
  @override
  KoGroupsPotsCreatingContext<T> getContext() =>
      context as KoGroupsPotsCreatingContext<T>;

  @override
  void constructGroupsAndRemainingEntities() {
    List<T> priorityEntities = [];

    for (var drawRoundIndex = 0;
        drawRoundIndex < getContext().pots.length;
        drawRoundIndex++) {
      var pot = getContext().pots[drawRoundIndex];

      List<T> addedPriorities = [];
      for (var prioritiedEntity in priorityEntities) {
        if (addedPriorities.length < groups.length) {
          var targetGroup = groupsWithSize(drawRoundIndex).first;
          targetGroup.entities.add(prioritiedEntity);
          addedPriorities.add(prioritiedEntity);
        }
      }

      priorityEntities.removeWhere((e) => addedPriorities.contains(e));

      List<T> addedFromPot = [];
      while (pot.isNotEmpty &&
          addedFromPot.length + addedPriorities.length < groups.length) {
        var entityFromPot = pot.removeAt(pot.indexOf(pot.randomElement()));
        var targetGroup = groupsWithSize(drawRoundIndex).first;
        targetGroup.entities.add(entityFromPot);
        addedFromPot.add(entityFromPot);
      }

      final remainingEntities = [
        ...pot,
        ...priorityEntities,
      ];

      priorityEntities = remainingEntities;
    }

    remainingEntities = priorityEntities;
  }

  @override
  int get entitiesInGroup => getContext().entitiesInGroup;

  @override
  KoGroupsCreatorRemainingEntitiesAction get remainingEntitiesAction =>
      getContext().remainingEntitiesAction;

  @override
  List<Object?> get props => [runtimeType];
}
