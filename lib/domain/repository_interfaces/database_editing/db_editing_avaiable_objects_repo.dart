class DbEditingAvailableObjectsRepo<T> {
  const DbEditingAvailableObjectsRepo(
      {List<DbEditingAvaiableObjectConfig<T>> initial = const []})
      : _objects = initial;

  final List<DbEditingAvaiableObjectConfig<T>> _objects;

  List<DbEditingAvaiableObjectConfig<T>> get objects => _objects;

  T getObject(String key) {
    return _getConfig(key).object;
  }

  String getDisplayName(String key) {
    return _getConfig(key).displayName;
  }

  String getKeyByObject(T searched) {
    return _objects.singleWhere((object) => object.object == searched).key;
  }

  DbEditingAvaiableObjectConfig<T> _getConfig(String key) {
    if (!containsKey(key)) {
      throw _objectWithKeyNotContainedError(key);
    }
    return _objects.singleWhere((config) => config.key == key);
  }

  bool containsKey(String key) {
    return _objects.any((config) => config.key == key);
  }

  Error _objectWithKeyNotContainedError(String key) {
    return StateError(
      'An object with that key ($key) is not contained in that DbEditingAvailableObjectsRepo<$T>',
    );
  }
}

class DbEditingAvaiableObjectConfig<T> {
  const DbEditingAvaiableObjectConfig({
    required this.key,
    required this.displayName,
    required this.object,
  });

  final String key;
  final String displayName;
  final T object;
}
