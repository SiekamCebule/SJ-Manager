import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';

class ItemsRepo<T> extends ValueRepo<List<T>> {
  ItemsRepo({super.initial});

  @override
  ValueStream<List<T>> get items;

  @override
  List<T> get last => items.value;

  int get lastLength => last.length;
}
