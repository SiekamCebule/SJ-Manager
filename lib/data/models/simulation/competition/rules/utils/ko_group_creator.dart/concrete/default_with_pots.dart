import 'package:sj_manager/data/models/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/utilities/utils/iterable.dart';

class DefaultPotsKoGroupsCreator<E>
    extends DefaultSizedKoGroupsCreator<E, KoGroupsPotsCreatingContext<E>> {
  @override
  void constructGroupsAndRemainingEntities() {
    List<E> priorityEntities = [];

    for (var drawRoundIndex = 0; drawRoundIndex < context.pots.length; drawRoundIndex++) {
      var pot = context.pots[drawRoundIndex];

      List<E> addedPriorities = [];
      for (var prioritiedEntity in priorityEntities) {
        if (addedPriorities.length < groups.length) {
          var targetGroup = groupsWithSize(drawRoundIndex).first;
          targetGroup.entities.add(prioritiedEntity);
          addedPriorities.add(prioritiedEntity);
        }
      }

      priorityEntities.removeWhere((e) => addedPriorities.contains(e));

      List<E> addedFromPot = [];
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
  int get entitiesInGroup => context.entitiesInGroup;

  @override
  KoGroupsCreatorRemainingEntitiesAction get remainingEntitiesAction =>
      context.remainingEntitiesAction;

  @override
  List<Object?> get props => [runtimeType];
}
