import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';

class ItemsRepo<T> extends ValueRepo<Iterable<T>> {
  ItemsRepo({super.initial});

  @override
  ValueStream<Iterable<T>> get items;

  Type get itemsType => T;

  @override
  Iterable<T> get last => items.valueOrNull ?? [];

  int get lastLength => last.length;
}
