class DefaultItemsRepo {
  DefaultItemsRepo({Set<dynamic> initial = const {}}) : _items = Set.of(initial) {
    _throwIfHasDuplicates();
  }

  final Set<dynamic> _items;

  void register<T>(T item, {bool overwrite = false}) {
    if (exist<T>()) {
      throw StateError(
          'An item of type $T already exist in DefaultItemsRepo, but overwrite flag is set to false');
    }
    _items.add(item);
  }

  T get<T>() {
    return getByTypeArgument(T);
  }

  dynamic getByTypeArgument(Type type) {
    return _items.singleWhere((item) => item.runtimeType == type);
  }

  bool exist<T>() {
    return _items.whereType<T>().length == 1;
  }

  void _throwIfHasDuplicates() {
    final byType = <Type, List>{};
    for (var item in _items) {
      if (!byType.containsKey(item.runtimeType)) {
        byType[item.runtimeType] = [item];
      } else {
        byType[item.runtimeType]!.add(item);
      }
    }
    int? excessiveLength;
    if (byType.values.any((items) {
      if (items.length > 1) {
        excessiveLength = items.length;
        return true;
      }
      return false;
    })) {
      throw StateError(
          'DefaultItemsRepo has $excessiveLength items of some type, when it can only have zero or one item');
    }
  }
}
