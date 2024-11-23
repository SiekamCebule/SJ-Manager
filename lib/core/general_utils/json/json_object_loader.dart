abstract interface class JsonObjectLoader<I, R> {
  Future<R> load(I object);
}
