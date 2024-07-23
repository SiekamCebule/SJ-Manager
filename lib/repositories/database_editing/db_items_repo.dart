import 'package:rxdart/rxdart.dart';

abstract class DbItemsRepo<T> {
  const DbItemsRepo();

  ValueStream<List<T>> get items;
  List<T> get lastItems => items.value;
  int get lastLength => lastItems.length;
}
