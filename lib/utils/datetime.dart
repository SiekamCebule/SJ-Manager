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
  if (today.difference(targetDate) < const Duration(hours: 24)) {
    return today.day == targetDate.day;
  }
  return false;
}
