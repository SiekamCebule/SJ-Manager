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
