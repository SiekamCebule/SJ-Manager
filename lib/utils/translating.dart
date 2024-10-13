import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';

String pluralForm({
  required int count,
  required String one,
  required String few,
  required String many,
}) {
  return switch (count) {
    == 0 => many,
    == 1 => one,
    >= 2 && <= 4 => few,
    _ => many,
  };
}

String sjmShortDateDescription(
    {required BuildContext context,
    required DateTime currentDate,
    required DateTime targetDate}) {
  final Duration difference = targetDate.difference(currentDate);
  final int daysDifference = difference.inDays;
  final int hoursDifference = difference.inHours;

  final translator = translate(context);

  if (daysDifference == 0 && hoursDifference < 24) {
    return translator.today;
  } else if (daysDifference == 1 && hoursDifference < 48) {
    return translator.tomorrow;
  } else if (daysDifference == 2 && hoursDifference < 72) {
    return translator.dayAfterTomorrow;
  } else if (daysDifference > 2) {
    return translator.inNDays(daysDifference);
  } else {
    throw ArgumentError('The target date must be today or in the future.');
  }
}
