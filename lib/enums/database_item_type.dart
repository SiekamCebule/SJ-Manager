enum DatabaseItemType {
  maleJumper,
  femaleJumper;

  static DatabaseItemType fromIndex(int index) {
    return switch (index) {
      0 => DatabaseItemType.maleJumper,
      1 => DatabaseItemType.femaleJumper,
      _ => throw StateError('Invalid index'),
    };
  }
}
