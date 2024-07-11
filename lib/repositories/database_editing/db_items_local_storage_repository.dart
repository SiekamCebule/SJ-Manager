import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';

class DbItemsLocalStorageRepository<T> implements DbItemsRepository<T> {
  DbItemsLocalStorageRepository({
    required this.storageFile,
    required this.fromJson,
    required this.toJson,
  });

  T Function(Json json) fromJson;
  Json Function(T object) toJson;
  final File storageFile;

  var _cachedItems = <T>[];
  final _subject = BehaviorSubject<Iterable<T>>();

  @override
  Future<DbItemsRepository<T>> clone() async {
    final repo = DbItemsLocalStorageRepository(
      storageFile: storageFile,
      fromJson: fromJson,
      toJson: toJson,
    );
    await repo.loadRaw(List.of(_cachedItems));
    return repo;
  }

  @override
  Future<void> add(T item, [int? index]) async {
    _cachedItems.insert(index ?? _cachedItems.length, item);
    _addToStream();
  }

  @override
  Future<void> remove(T item) async {
    _cachedItems.remove(item);
    _addToStream();
  }

  @override
  Future<T> removeAt(int index) async {
    final removed = _cachedItems.removeAt(index);
    _addToStream();
    return removed;
  }

  @override
  Future<void> clear() async {
    _cachedItems.clear();
    _addToStream();
  }

  @override
  Future<void> loadRaw(Iterable<T> items) async {
    _cachedItems = items.toList();
    _addToStream();
  }

  @override
  Future<void> move({required int from, required int to}) async {
    final removed = _cachedItems.removeAt(from);
    _cachedItems.insert(to, removed);
    _addToStream();
  }

  @override
  Future<void> replace({required int oldIndex, required T newItem}) async {
    _cachedItems[oldIndex] = newItem;
    _addToStream();
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
    _addToStream();
  }

  @override
  Future<void> saveToSource() async {
    final itemsInJson = _cachedItems.map((item) => toJson(item)).toList();
    await storageFile.writeAsString(jsonEncode(itemsInJson));
  }

  void _addToStream() {
    _subject.add(_cachedItems);
  }

  @override
  ValueStream<Iterable<T>> get items => _subject.stream;
}
