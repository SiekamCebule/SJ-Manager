import 'package:equatable/equatable.dart';

abstract class Filter<T> extends Equatable {
  const Filter();

  List<T> call(List<T> source);

  bool get isValid;

  static List<T> filterAll<T>(List<T> source, List<Filter<T>> filters) {
    var filtered = List.of(source);
    print('AT BEGINNING: $filtered');
    for (var filter in filters) {
      print('FILTERED: $filtered');
      filtered = filter(filtered);
    }
    print('FILTERED AT THE END: $filtered');
    return filtered;
  }
}
