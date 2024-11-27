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

String sjmDeadlineDateDescription({
  required BuildContext context,
  required DateTime currentDate,
  required DateTime? targetDate,
}) {
  return targetDate == null
      ? translate(context).noDeadline
      : sjmFutureDateDescription(
          context: context, currentDate: currentDate, targetDate: targetDate);
}

String sjmFutureDateDescription({
  required BuildContext context,
  required DateTime currentDate,
  required DateTime targetDate,
}) {
  final Duration difference = targetDate.difference(currentDate);
  final int hoursDifference = difference.inHours;

  if (difference.isNegative) {
    throw ArgumentError(
        'The target date must be today or in the future. Difference: $difference');
  }

  if (hoursDifference < 24) {
    return sjmFutureDaysDescription(context: context, days: 0);
  } else if (hoursDifference < 48) {
    return sjmFutureDaysDescription(context: context, days: 1);
  } else if (hoursDifference < 72) {
    return sjmFutureDaysDescription(context: context, days: 2);
  } else {
    return sjmFutureDaysDescription(context: context, days: difference.inDays);
  }
}

String sjmFutureDaysDescription({
  required BuildContext context,
  required int days,
}) {
  final translator = translate(context);
  if (days == 0) {
    return translator.today;
  } else if (days == 1) {
    return translator.tomorrow;
  } else if (days == 2) {
    return translator.dayAfterTomorrow;
  } else if (days > 2) {
    return translator.inNDays(days);
  } else {
    throw ArgumentError('The days parameter must be positive.');
  }
}
