import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/repositories/generic/db_items_repo.dart';

class EditableDbItemsRepo<T> extends DbItemsRepo<T> {
  EditableDbItemsRepo({
    List<T>? initial,
  }) : _items = initial ?? [] {
    _subject.add(_items);
  }

  List<T> _items;
  final _subject = BehaviorSubject<List<T>>();

  EditableDbItemsRepo<T> clone() {
    return EditableDbItemsRepo(initial: List.of(_items));
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

  @override
  void set(Iterable<T> value) {
    _items = value.toList();
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

  @override
  List<T> get last => items.value;
  @override
  ValueStream<List<T>> get items => _subject.stream;
}
