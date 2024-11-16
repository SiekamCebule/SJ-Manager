import 'package:equatable/equatable.dart';

class Filter<T> with EquatableMixin {
  const Filter({
    required this.shouldPass,
  });

  final bool Function(T item) shouldPass;

  Iterable<T> call(Iterable<T> source) {
    return source.where(shouldPass);
  }

  static Iterable<T> filterAll<T>(Iterable<T> source, Iterable<Filter<T>> filters) {
    var filtered = List<T>.of(source);
    for (var filter in filters) {
      filtered = filter(filtered).toList();
    }
    return filtered;
  }

  @override
  List<Object?> get props => [
        shouldPass,
      ];
}
