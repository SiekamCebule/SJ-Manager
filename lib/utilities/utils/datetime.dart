bool isTomorrow({
  required DateTime today,
  required DateTime targetDate,
}) {
  return today.difference(targetDate) < const Duration(hours: 48);
}

bool isSameDay({
  required DateTime today,
  required DateTime targetDate,
}) {
  return today.year == targetDate.year &&
      today.month == targetDate.month &&
      today.day == targetDate.day;
}

int daysInMonth(int year, int month) {
  DateTime firstDayOfNextMonth =
      (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);

  DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));
  return lastDayOfMonth.day;
}
