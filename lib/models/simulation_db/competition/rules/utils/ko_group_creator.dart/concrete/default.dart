import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_group.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/utils/iterable.dart';

enum KoGroupsCreatorRemainingEntitiesAction {
  placeRandomly,
  placeAtBegin,
  placeAtEnd,
  doNothing,
  throwError,
}

abstract class DefaultSizedKoGroupsCreator<E, C extends KoGroupsCreatingContext<E>>
    extends KoGroupsCreator<E, C> with EquatableMixin {
  late C context;
  List<KoGroup<E>> koGroups = [];
  List<E> remainingEntities = [];

  int get entitiesInGroup;
  KoGroupsCreatorRemainingEntitiesAction get remainingEntitiesAction;

  @override
  List<KoGroup<E>> compute(C context) {
    setUpContext(context);
    validateData();
    setUpGroups();
    constructGroupsAndRemainingEntities();
    allocateRemainingEntities();
    return koGroups;
  }

  void setUpContext(C context) {
    this.context = context;
  }

  void validateData() {
    final entitiesLengthIsDividableByPassedSize =
        context.entitiesCount % entitiesInGroup == 0;
    final shouldThrow = !entitiesLengthIsDividableByPassedSize &&
        remainingEntitiesAction == KoGroupsCreatorRemainingEntitiesAction.throwError;
    if (shouldThrow) {
      throw StateError(
        'Passed entities list length (${context.entitiesCount}) is not dividable by passed entitiesInGroup ($entitiesInGroup), and remainingEntitiesAction is set to $remainingEntitiesAction',
      );
    }
  }

  void setUpGroups() {
    koGroups = List.generate(
      context.entitiesCount ~/ entitiesInGroup,
      (_) => const KoGroup(
        entities: [],
      ),
    );
  }

  void constructGroupsAndRemainingEntities();

  bool get everyGroupAreFull {
    return groupsWithSize(entitiesInGroup).isEmpty;
  }

  List<KoGroup> groupsWithSize(int size) {
    return koGroups.where((group) => group.size == size).toList();
  }

  List<KoGroup> get nonFullGroups {
    return koGroups
        .whereNot((group) => group.entities.length == entitiesInGroup)
        .toList();
  }

  void allocateRemainingEntities() {
    for (var entity in remainingEntities) {
      switch (remainingEntitiesAction) {
        case KoGroupsCreatorRemainingEntitiesAction.placeAtBegin:
          koGroups.first.entities.add(entity);
        case KoGroupsCreatorRemainingEntitiesAction.placeAtEnd:
          koGroups.last.entities.add(entity);
        case KoGroupsCreatorRemainingEntitiesAction.placeRandomly:
          koGroups.randomElement().entities.add(entity);
        case KoGroupsCreatorRemainingEntitiesAction.doNothing:
          break;
        case KoGroupsCreatorRemainingEntitiesAction.throwError:
          throw StateError(
            'That shouldn\'t even occur, because it should be handled earlier. allocateRemainingEntities(). remainingEntitiesAction is set to \'throwError\'',
          );
      }
    }
  }

  @override
  List<Object?> get props => [
        runtimeType,
      ];
}
