enum EditableDbItemType {
  maleJumper,
  femaleJumper,
  hill,
  eventSeriesSetup,
  eventSeriesCalendarPreset,
  competitionRulesPreset;

  static EditableDbItemType fromIndex(int index) {
    if (index < 0 || index >= EditableDbItemType.values.length) {
      throw StateError('Invalid index');
    }
    return EditableDbItemType.values[index];
  }
}
