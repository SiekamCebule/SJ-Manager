import 'package:flutter/material.dart';
import 'package:sj_manager/json/db_items_json.dart';

class ItemsIdsRepo<ID extends Object> {
  final Map<ID, _ItemWithCount> _items = {};
  final Map<dynamic, ID> _reverseItems = {};
  final List<ID> _orderedIds = [];

  T get<T>(ID id) {
    final item = maybeGet(id);
    if (item == null) {
      throw StateError(
          'Ids repo does not contain any object of type $T with that id ($id)');
    }
    if (item is T == false) {
      throw StateError('The item ($item) doesn\'t have the requested type of $T');
    }
    return item;
  }

  T? maybeGet<T>(ID id) {
    return _items[id]?.item;
  }

  ID idOf(dynamic item) {
    final id = maybeIdOf(item);
    if (id == null) {
      throw StateError('Ids repo does not contain the item ($item)');
    }
    return id;
  }

  ID? maybeIdOf(dynamic item) {
    return _reverseItems[item];
  }

  int countOfItemsWithId(ID id) {
    return _items[id]?.count ?? 0;
  }

  void update({
    required ID id,
    required dynamic newItem,
  }) {
    if (!containsId(id)) {
      throw StateError(
          'Cannot update the item because the id ($id) does not exist in the repository.');
    }
    final oldItem = _items[id]!.item;
    _items[id] = _ItemWithCount(newItem, _items[id]!.count);

    _reverseItems.remove(oldItem);
    _reverseItems[newItem] = id;
  }

  void removeById({required ID id}) {
    final entry = _items[id];
    if (entry == null) {
      throw StateError(
          'Cannot remove an item with id of $id, because it does not even exist in the repo');
    }

    if (entry.count > 1) {
      entry.count--;
    } else {
      _reverseItems.remove(entry.item);
      _items.remove(id);
    }
    _orderedIds.remove(id);
  }

  ID removeByItem({required dynamic item}) {
    final id = _reverseItems[item];
    if (id == null) {
      throw StateError(
          'Cannot remove an item $item, because it doesn\'t even exist in the repo');
    }
    removeById(id: id);
    return id;
  }

  void register(dynamic item, {required ID id}) {
    if (containsItem(item)) {
      final id = _reverseItems[item]!;
      _items[id]!.count++;
      _orderedIds.add(id);
    } else {
      _items[id] = _ItemWithCount(item, 1);
      _reverseItems[item] = id;
      _orderedIds.add(id);
    }
  }

  void registerMany(
    Iterable<dynamic> items, {
    required Function(dynamic item) generateId,
    bool skipDuplicates = false,
  }) {
    for (var item in items) {
      final id = generateId(item);
      register(item, id: id);
    }
  }

  void registerFromLoadedItemsMap<T>(
    LoadedItemsMap<T> loadedItemsMap,
  ) {
    loadedItemsMap.items.forEach((id, itemAndCount) {
      register(itemAndCount.$1, id: id);
    });
  }

  bool containsId(ID id) {
    return _items.containsKey(id);
  }

  bool containsItem(dynamic item) {
    return _reverseItems.containsKey(item);
  }

  List<dynamic> getOrderedItems() {
    return _orderedIds.map((id) => _items[id]!.item).toList();
  }

  void clear() {
    _items.clear();
    _reverseItems.clear();
    _orderedIds.clear();
  }

  void debug() {
    items.forEach((id, item) {
      debugPrint('$id ==> $item');
    });
  }

  Map<ID, dynamic> get items => _items.map((id, entry) => MapEntry(id, entry.item));
  int get itemsCount => _items.length;
}

class _ItemWithCount {
  final dynamic item;
  int count;

  _ItemWithCount(this.item, this.count);
}
