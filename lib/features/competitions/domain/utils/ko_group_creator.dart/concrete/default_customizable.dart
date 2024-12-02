import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/context/ko_groups_creator_context.dart';

abstract class DefaultCustomizableKoGroupsCreator<T>
    extends DefaultSizedKoGroupsCreator<T> {
  @override
  KoGroupsCustomizableCreatingContext<T> getContext() =>
      context as KoGroupsCustomizableCreatingContext<T>;

  @override
  KoGroupsCreatorRemainingEntitiesAction get remainingEntitiesAction =>
      getContext().remainingEntitiesAction;

  @override
  int get entitiesInGroup => getContext().entitiesInGroup;

  @override
  List<Object?> get props => [runtimeType];
}
