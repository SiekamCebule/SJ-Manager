import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/utilities/json/db_items_json.dart';

class ItemsIdsRepo<ID extends Object> {
  ItemsIdsRepo();

  static ItemsIdsRepo<ID> copyFrom<ID extends Object>(ItemsIdsRepo<ID> other) {
    final copiedRepo = ItemsIdsRepo<ID>();
    other._items.forEach((id, itemWithCount) {
      copiedRepo._items[id] = _ItemWithCount(itemWithCount.item, itemWithCount.count);
    });
    copiedRepo._reverseItems.addAll(other._reverseItems);
    copiedRepo._orderedIds.addAll(other._orderedIds);
    return copiedRepo;
  }

  final Map<ID, _ItemWithCount> _items = {};
  final Map<ID, ID> _reverseItems = {};
  final LinkedHashMap<ID, bool> _orderedIds = LinkedHashMap();

  T get<T>(ID id) {
    final item = maybeGet<T>(id);
    if (item == null) {
      throw StateError(
          'Ids repo does not contain any object of type $T with that id ($id)');
    }
    return item;
  }

  T? maybeGet<T>(ID id) {
    return _items[id]?.item as T?;
  }

  ID id(dynamic item) {
    final id = maybeIdOf(item);
    if (id == null) {
      throw StateError('Ids repo does not contain the item ($item)');
    }
    return id;
  }

  ID? maybeIdOf(dynamic item) {
    return _items.entries.firstWhereOrNull((entry) => entry.value.item == item)?.key;
  }

  int countOfItemsWithId(ID id) {
    return _items[id]?.count ?? 0;
  }

  void update({required ID id, required dynamic newItem}) {
    if (!containsId(id)) {
      throw StateError(
          'Cannot update the item because the id ($id) does not exist in the repository.');
    }
    _items[id] = _ItemWithCount(newItem, _items[id]!.count);
  }

  bool removeById({required ID id}) {
    final entry = _items[id];
    if (entry == null) {
      return false;
    }
    if (entry.count > 1) {
      entry.count--;
    } else {
      _items.remove(id);
      _reverseItems.remove(id);
    }
    _orderedIds.remove(id);
    return true;
  }

  ID removeByItem({required dynamic item}) {
    final id = maybeIdOf(item);
    if (id == null) {
      throw StateError(
          'Cannot remove an item $item, because it does not even exist in the repo');
    }
    removeById(id: id);
    return id;
  }

  void register(dynamic item, {required ID id}) {
    if (containsItem(item)) {
      final existingId = maybeIdOf(item)!;
      _items[existingId]!.count++;
      _orderedIds[existingId] = true;
    } else {
      _items[id] = _ItemWithCount(item, 1);
      _reverseItems[id] = id;
      _orderedIds[id] = true;
    }
  }

  void registerMany(
    Iterable<dynamic> items, {
    required Function(dynamic item) generateId,
    bool skipDuplicates = false,
  }) {
    for (var item in items) {
      final id = generateId(item);
      if (skipDuplicates && containsItem(item)) {
        continue;
      }
      register(item, id: id);
    }
  }

  void registerFromLoadedItemsMap<T>(LoadedItemsMap<T> loadedItemsMap) {
    loadedItemsMap.items.forEach((id, itemAndCount) {
      for (int i = 0; i < itemAndCount.$2; i++) {
        register(itemAndCount.$1, id: id);
      }
    });
  }

  bool containsId(ID id) {
    return _items.containsKey(id);
  }

  bool containsItem(dynamic item) {
    return maybeIdOf(item) != null;
  }

  List<dynamic> getOrderedItems() {
    return _orderedIds.keys.map((id) => _items[id]!.item).toList();
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
