abstract interface class Filter<T> {
  List<T> call(List<T> source);

  static List<T> filterAll<T>(List<T> source, Set<Filter<T>> filters) {
    var filtered = List.of(source);
    for (var filter in filters) {
      filtered = filter(filtered);
    }
    return filtered;
  }
}
