import 'package:equatable/equatable.dart';

abstract class Filter<T> extends Equatable {
  const Filter();

  List<T> call(List<T> source);

  bool get isValid;

  static List<T> filterAll<T>(List<T> source, Set<Filter<T>> filters) {
    var filtered = List.of(source);
    for (var filter in filters) {
      filtered = filter(filtered);
      print('filtered: $filtered');
    }
    return filtered;
  }
}
