import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';

abstract class DbItemsRepo<T> extends ValueRepo<List<T>> {
  DbItemsRepo({super.initial});

  @override
  ValueStream<List<T>> get items;

  @override
  List<T> get lastItems => items.value;

  int get lastLength => lastItems.length;
}
