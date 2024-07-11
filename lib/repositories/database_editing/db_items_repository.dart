import 'package:rxdart/rxdart.dart';

abstract interface class DbItemsRepository<T> {
  const DbItemsRepository();

  Future<DbItemsRepository<T>> clone();

  Future<void> add(T item, [int? index]);

  Future<void> remove(T item);

  Future<T> removeAt(int index);

  Future<void> clear();

  Future<void> loadRaw(Iterable<T> items);

  Future<void> move({required int from, required int to});

  Future<void> replace({required int oldIndex, required T newItem});

  Future<void> loadFromSource();

  Future<void> saveToSource();

  ValueStream<Iterable<T>> get items;
}
