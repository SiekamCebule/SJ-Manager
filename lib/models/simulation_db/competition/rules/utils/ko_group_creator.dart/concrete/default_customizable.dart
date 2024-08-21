import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';

abstract class DefaultCustomizableKoGroupsCreator<E,
        C extends KoGroupsCustomizableCreatingContext<E>>
    extends DefaultSizedKoGroupsCreator<E, C> {
  @override
  KoGroupsCreatorRemainingEntitiesAction get remainingEntitiesAction =>
      context.remainingEntitiesAction;

  @override
  int get entitiesInGroup => context.entitiesInGroup;
}
