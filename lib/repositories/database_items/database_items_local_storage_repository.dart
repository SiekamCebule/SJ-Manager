import 'dart:convert';
import 'dart:io';

import 'package:sj_manager/json/convertable_to_json.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/repositories/database_items/database_items_api.dart';

class DatabaseItemsLocalStorageRepository<T extends ConvertableToJson<T>>
    implements DatabaseItemsApi<T> {
  DatabaseItemsLocalStorageRepository({
    required this.storageFile,
    required this.fromJson,
  });

  T Function(Json json) fromJson;
  final File storageFile;
  var _cachedItems = <T>[];

  @override
  Future<DatabaseItemsApi<T>> clone() async {
    final repo = DatabaseItemsLocalStorageRepository(
      storageFile: storageFile,
      fromJson: fromJson,
    );
    await repo.loadRaw(List.of(items));
    return repo;
  }

  @override
  Future<void> save(T item, [int? index]) async {
    _cachedItems.insert(index ?? _cachedItems.length, item);
  }

  @override
  Future<void> remove(T item) async {
    _cachedItems.remove(item);
  }

  @override
  Future<T> removeAt(int index) async {
    final removed = _cachedItems.removeAt(index);
    return removed;
  }

  @override
  Future<void> clear() async {
    _cachedItems.clear();
  }

  @override
  Future<void> loadRaw(Iterable<T> items) async {
    _cachedItems = items.toList();
  }

  @override
  Future<void> move({required int from, required int to}) async {
    final removed = _cachedItems.removeAt(from);
    _cachedItems.insert(to, removed);
  }

  @override
  Future<void> replace({required int oldIndex, required T newItem}) async {
    _cachedItems[oldIndex] = newItem;
  }

  @override
  Future<void> loadFromSource() async {
    final fileContent = await storageFile.readAsString();
    final itemsInJson = jsonDecode(fileContent) as List<dynamic>;
    _cachedItems = itemsInJson
        .map(
          (itemInJson) => fromJson(itemInJson),
        )
        .toList();
  }

  @override
  Future<void> saveToSource() async {
    final itemsInJson = _cachedItems.map((item) => item.toJson()).toList();
    await storageFile.writeAsString(jsonEncode(itemsInJson));
  }

  @override
  Iterable<T> get items => _cachedItems;
}
