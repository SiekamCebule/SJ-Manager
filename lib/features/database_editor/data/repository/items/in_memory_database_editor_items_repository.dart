import 'package:collection/collection.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';

class InMemoryDatabaseEditorItemsRepository<T>
    implements DatabaseEditorItemsRepository<T> {
  InMemoryDatabaseEditorItemsRepository({
    Iterable<T>? initial,
  }) : _items = initial?.toList() ?? [];

  final List<T> _items;

  @override
  Future<void> add(T item, [int? index]) async {
    _items.insert(index ?? _items.length, item);
  }

  @override
  Future<void> removeAt(int index) async {
    _items.removeAt(index);
  }

  @override
  Future<void> removeMany(Set<int> indexes) async {
    final sortedIndexes = indexes.sorted((a, b) => b.compareTo(a));
    for (final index in sortedIndexes) {
      removeAt(index);
    }
  }

  @override
  Future<List<T>> getAll() async => _items;

  @override
  Future<void> move(int index, int targetIndex) async {
    final removed = _items.removeAt(index);
    _items.insert(targetIndex, removed);
  }

  @override
  Future<void> update(int index, T item) async {
    _items[index] = item;
  }
}
