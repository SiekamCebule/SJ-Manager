abstract interface class ItemsFromGameVariantDataSource<T> {
  Future<Iterable<T>> loadAll();
  Future<void> saveAll();
}
