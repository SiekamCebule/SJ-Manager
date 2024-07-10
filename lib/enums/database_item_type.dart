enum DatabaseItemType {
  maleJumper,
  femaleJumper,
  hill;

  static DatabaseItemType fromIndex(int index) {
    return switch (index) {
      0 => DatabaseItemType.maleJumper,
      1 => DatabaseItemType.femaleJumper,
      2 => DatabaseItemType.hill,
      _ => throw StateError('Invalid index'),
    };
  }
}
