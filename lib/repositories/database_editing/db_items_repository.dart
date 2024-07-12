import 'package:rxdart/rxdart.dart';

class DbItemsRepo<T> {
  DbItemsRepo({
    List<T>? initial,
  }) : _items = initial ?? [] {
    _subject.add(_items);
  }

  List<T> _items;
  final _subject = BehaviorSubject<List<T>>();

  DbItemsRepo<T> clone() {
    return DbItemsRepo(initial: List.of(_items));
  }

  void add(T item, [int? index]) {
    _items.insert(index ?? _items.length, item);
    _addToStream();
  }

  void remove(T item) {
    _items.remove(item);
    _addToStream();
  }

  T removeAt(int index) {
    final removed = _items.removeAt(index);
    _addToStream();
    return removed;
  }

  void clear() {
    _items.clear();
    _addToStream();
  }

  void setItems(Iterable<T> items) {
    _items = items.toList();
    _addToStream();
  }

  void move({required int from, required int to}) {
    final removed = _items.removeAt(from);
    _items.insert(to, removed);
    _addToStream();
  }

  void replace({required int oldIndex, required T newItem}) {
    _items[oldIndex] = newItem;
    _addToStream();
  }

  void _addToStream() {
    _subject.add(_items);
  }

  List<T> get lastItems => items.value;
  ValueStream<List<T>> get items => _subject.stream;
}
