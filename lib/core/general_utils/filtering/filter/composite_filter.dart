import 'package:sj_manager/core/general_utils/filtering/filter/filter.dart';

class CompositeFilter<T> implements Filter<T> {
  const CompositeFilter({
    required this.filters,
  });

  final Iterable<Filter<T>> filters;

  @override
  Iterable<T> call(Iterable<T> source) {
    Iterable<T> currentItems = List.of(source);
    for (var filter in filters) {
      currentItems = filter(currentItems);
    }
    return currentItems;
  }

  @override
  bool get isValid =>
      filters.isNotEmpty ? filters.every((filter) => filter.isValid) : false;
}
