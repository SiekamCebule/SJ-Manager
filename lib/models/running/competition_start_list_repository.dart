import 'package:equatable/equatable.dart';

class CompetitionStartlistRepo<E> with EquatableMixin {
  CompetitionStartlistRepo.fromEntitiesList({
    required List<E> entities,
  })  : _completionMap = {for (var entity in entities) entity: false},
        _startlistOrder = entities;

  final List<E> _startlistOrder;
  final Map<E, bool> _completionMap;

  bool _contains(E entity) => _completionMap.containsKey(entity);

  void complete(E entity) {
    if (!_completionMap.containsKey(entity)) {
      throw _entityIsNotContainedError(entity);
    }
    if (_completionMap[entity] == true) {
      throw _alreadyCompletedError(entity);
    }
    _completionMap[entity] = true;
  }

  Error _entityIsNotContainedError(E entity) =>
      StateError('The entity ($entity) is not even contained in the repository');

  Error _alreadyCompletedError(E entity) => StateError(
      'Cannot complete the jump again, because the $E\'s jump has been already completed');

  bool of(E entity) {
    if (!_contains(entity)) {
      throw _entityIsNotContainedWhenCheckingError(entity);
    }
    return _completionMap[entity]!;
  }

  Error _entityIsNotContainedWhenCheckingError(E entity) =>
      StateError('The entity ($entity) is not contained in the repository');

  E get firstIncompleted {
    if (everyHasCompleted) {
      throw _everyEntityHasCompletedError();
    }
    return _startlistOrder.firstWhere(
      (entity) => of(entity) == true,
    );
  }

  bool get everyHasCompleted {
    return _completionMap.values.every((value) => value == true);
  }

  Error _everyEntityHasCompletedError() => StateError(
      'Tried to get first entity which hasn\'t completed, but every entity has completed its jump');

  void moveEntity({required E entity, required int newIndex}) {
    late final int currentIndex;
    try {
      currentIndex = _startlistOrder.indexOf(entity);
    } on StateError {
      throw _entityIsNotContainedError(entity);
    }
    final removed = _startlistOrder.removeAt(currentIndex);
    _startlistOrder.insert(newIndex - 1, removed); // TODO: I should test it
  }

  @override
  List<Object?> get props => [
        _startlistOrder,
        _completionMap,
      ];
}
