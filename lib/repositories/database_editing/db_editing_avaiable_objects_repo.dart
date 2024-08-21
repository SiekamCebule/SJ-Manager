class DbEditingAvaiableObjectsRepo<T> {
  const DbEditingAvaiableObjectsRepo({Map<String, T> initial = const {}})
      : _objects = initial;

  final Map<String, T> _objects;

  // If I add add() method or sth, I should remove the const from assignement to [initial]

  T get(String key) {
    if (!_objects.containsKey(key)) {
      throw _objectWithKeyNotContainedError(key);
    }
    return _objects[key]!;
  }

  Error _objectWithKeyNotContainedError(String key) {
    return StateError(
      'An object with that key ($key) is not contained in that DbEditingAvaiableObjectsRepo<$T>',
    );
  }
}
