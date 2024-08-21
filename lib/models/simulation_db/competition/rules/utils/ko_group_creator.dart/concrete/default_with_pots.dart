import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/utils/iterable.dart';

class DefaultPotsKoGroupsCreator<E>
    extends DefaultSizedKoGroupsCreator<E, KoGroupsPotsCreatingContext<E>> {
  @override
  void constructGroupsAndRemainingEntities() {
    final pots = entitiesInGroup;
    final entitiesInPot = context.entities.length ~/ pots;
    final entityPots = <List<E>>[];
    for (var potIndex = 0; potIndex < pots; potIndex++) {
      entityPots.add(
        context.entities.sublist(
          potIndex * entitiesInPot,
          (potIndex + 1) * entitiesInPot,
        ),
      );
    }

    if (context.entities.length > pots * entitiesInPot) {
      remainingEntities = context.entities.sublist(pots * entitiesInPot);
    }

    for (var potIndex = 0; potIndex < pots; potIndex++) {
      for (var entity in entityPots[potIndex]) {
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
