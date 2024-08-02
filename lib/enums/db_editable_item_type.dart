enum DbEditableItemType {
  maleJumper,
  femaleJumper,
  hill,
  eventSeriesSetup,
  eventSeriesCalendarPreset,
  competitionRulesPreset;

  static DbEditableItemType fromIndex(int index) {
    if (index < 0 || index >= DbEditableItemType.values.length) {
      throw StateError('Invalid index');
    }
    return DbEditableItemType.values[index];
  }
}
