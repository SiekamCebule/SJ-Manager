abstract interface class DatabaseEditorItemsRepository<T> {
  Future<void> add(T item, [int? index]);
  Future<void> removeAt(int index);
  Future<void> removeMany(Set<int> indexes);
  Future<void> update(int index, T item);
  Future<void> move(int index, int targetIndex);
  Future<List<T>> getAll();
  Future<void> load();
  Future<void> save();
}
