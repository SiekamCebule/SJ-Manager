abstract interface class DatabaseEditorSelectionRepository {
  Future<void> toggle(int index);
  Future<void> selectOnly(int index);
  Future<void> selectRange(int start, int end);
  Future<void> deselect(int index);
  Future<void> clear();
  Future<Set<int>> getSelection();
  Future<Stream<Set<int>>> get stream;
}
