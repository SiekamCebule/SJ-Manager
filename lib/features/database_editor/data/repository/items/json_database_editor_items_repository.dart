import 'package:collection/collection.dart';
import 'package:sj_manager/features/database_editor/data/data_sources/items_from_game_variant/items_from_game_variant_data_source.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';

class JsonDatabaseEditorItemsRepository<T> implements DatabaseEditorItemsRepository<T> {
  JsonDatabaseEditorItemsRepository({
    required this.itemsFromGameVariantDataSource,
  });

  final ItemsFromGameVariantDataSource<T> itemsFromGameVariantDataSource;

  late List<T> _items;

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

  @override
  Future<void> load() async {
    _items = (await itemsFromGameVariantDataSource.loadAll()).toList();
  }

  @override
  Future<void> save() async {
    await itemsFromGameVariantDataSource.saveAll();
  }
}
