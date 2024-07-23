enum DbEditableItemType {
  maleJumper,
  femaleJumper,
  hill;

  static DbEditableItemType fromIndex(int index) {
    return switch (index) {
      0 => DbEditableItemType.maleJumper,
      1 => DbEditableItemType.femaleJumper,
      2 => DbEditableItemType.hill,
      _ => throw StateError('Invalid index'),
    };
  }
}
