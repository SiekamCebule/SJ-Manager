import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/ko/ko_group.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/utilities/utils/iterable.dart';

enum KoGroupsCreatorRemainingEntitiesAction {
  placeRandomly,
  placeAtBegin,
  placeAtEnd,
  placeInSmallestGroup,
  doNothing,
  throwError,
}

abstract class DefaultSizedKoGroupsCreator<E, C extends KoGroupsCreatingContext<E>>
    extends KoGroupsCreator<E, C> with EquatableMixin {
  late C context;
  List<KoGroup<E>> groups = [];
  List<E> remainingEntities = [];

  int get entitiesInGroupForEvenGroups {
    return context.entitiesCount ~/ groups.length;
  }

  int get entitiesInGroup;
  KoGroupsCreatorRemainingEntitiesAction get remainingEntitiesAction;

  @override
  List<KoGroup<E>> compute(C context) {
    setUpContext(context);
    validateData();
    setUpGroups();
    constructGroupsAndRemainingEntities();
    allocateRemainingEntities();
    return groups;
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
      throw ArgumentError(
        'Passed entities list length (${context.entitiesCount}) is not dividable by passed entitiesInGroup ($entitiesInGroup), and remainingEntitiesAction is set to $remainingEntitiesAction',
      );
    }
  }

  void setUpGroups() {
    groups = List.generate(
      (context.entitiesCount ~/ entitiesInGroup).ceil(),
      (_) => KoGroup<E>(
        entities: [],
      ),
    );
  }

  void constructGroupsAndRemainingEntities();

  bool get everyGroupIsFull {
    return nonFullGroups.isEmpty;
  }

  List<KoGroup<E>> groupsWithSize(int size) {
    return groups.where((group) => group.size == size).toList();
  }

  List<KoGroup<E>> groupsWithSmallerSize(int size) {
    return groups.where((group) => group.size < size).toList();
  }

  List<KoGroup<E>> get nonFullGroups {
    return groups
        .whereNot((group) => group.entities.length == entitiesInGroupForEvenGroups)
        .toList();
  }

  void allocateRemainingEntities() {
    for (var entity in remainingEntities) {
      switch (remainingEntitiesAction) {
        case KoGroupsCreatorRemainingEntitiesAction.placeAtBegin:
          groups.first.entities.add(entity);
        case KoGroupsCreatorRemainingEntitiesAction.placeAtEnd:
          groups.last.entities.add(entity);
        case KoGroupsCreatorRemainingEntitiesAction.placeRandomly:
          groups.randomElement().entities.add(entity);
        case KoGroupsCreatorRemainingEntitiesAction.placeInSmallestGroup:
          var smallestGroup = nonFullGroups
              .reduce((a, b) => a.entities.length < b.entities.length ? a : b);
          smallestGroup.entities.add(entity);

        case KoGroupsCreatorRemainingEntitiesAction.doNothing:
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
