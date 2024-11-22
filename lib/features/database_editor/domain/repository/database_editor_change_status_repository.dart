abstract interface class DatabaseEditorChangeStatusRepository {
  Future<bool> get isChanged;
  Future<void> markAsChanged();
  Future<Stream<bool>> get stream;
}
