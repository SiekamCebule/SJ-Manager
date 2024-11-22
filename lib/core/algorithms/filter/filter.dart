abstract interface class Filter<T> {
  const Filter();

  bool get isValid;
  Iterable<T> call(Iterable<T> source);
}
