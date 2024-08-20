class ItemsIdsRepo<ID extends Object> {
  final Map<ID, dynamic> _items = {};

  T get<T>(ID id) {
    if (!_items.containsKey(id)) {
      throw StateError(
        'Ids repo does not contain any object of type $T with that id ($id)',
      );
    }
    final item = _items[id]!;
    if (!item is T) {
      throw StateError('The item ($item) doesn\'t have a requested type of $T');
    }
    return _items[id]!;
  }

  ID idOf(dynamic item) {
    return _items.keys.singleWhere((id) {
      return _items[id] == item;
    });
  }

  void register(dynamic item,
      {required ID id, bool override = false, bool overrideIfSameType = false}) {
    assert((!override && !overrideIfSameType) || (override ^ overrideIfSameType));
    if (_items.containsKey(id)) {
      if (!override) {
        throw StateError(
          'An item with the ID of $id already exists, and that item is $item. You can set the override parameter to true, if you want to override already contained item with that id',
        );
      } else if (overrideIfSameType) {
        final existingItem = _items[id]!;
        if (existingItem.runtimeType == item.runtimeType) {
          _items[id] = item;
        } else {
          throw StateError(
            'Existing item has the ${existingItem.runtimeType} type which is different from new item\'s type - ${item.runtimeType}. The overrideIfSameType flag is enabled, so cannot register the new item',
          );
        }
      }
    }
    _items[id] = item;
  }

  Map<ID, dynamic> get items => _items;
  int get itemsCount => items.length;
}
