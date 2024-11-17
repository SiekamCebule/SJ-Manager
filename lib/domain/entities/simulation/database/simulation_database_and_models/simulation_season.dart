import 'package:equatable/equatable.dart';
import 'package:sj_manager/utilities/extensions/string.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series.dart';

class SimulationSeason with EquatableMixin {
  const SimulationSeason({
    required this.eventSeries,
  });

  final List<EventSeries> eventSeries;

  DateTime get startDate {
    DateTime? firstDate;
    final calendars = eventSeries.map((eventSeries) => eventSeries.calendar).toList();
    for (var calendar in calendars) {
      final firstCompetitionDate = calendar.competitions.first.date;
      firstDate ??= firstCompetitionDate;
      if (firstCompetitionDate.isBefore(firstDate)) {
        firstDate = firstCompetitionDate;
      }
    }
    if (firstDate == null) {
      throw StateError(
        'The event series does not have any competitions, so cannot compute the start date',
      );
    }
    return firstDate;
  }

  DateTime get endDate {
    DateTime? lastDate;
    final calendars = eventSeries.map((eventSeries) => eventSeries.calendar).toList();
    for (var calendar in calendars) {
      final lastCompetitionDate = calendar.competitions.last.date;
      lastDate ??= lastCompetitionDate;
      if (lastCompetitionDate.isAfter(lastDate)) {
        lastDate = lastCompetitionDate;
      }
    }
    if (lastDate == null) {
      throw StateError(
        'The event series does not have any competitions, so cannot compute the end date',
      );
    }
    return lastDate;
  }

  String yearsFormattedString({
    bool twoDigit = false,
  }) =>
      getSimulationSeasonYearsFormattedString(
        startDate: startDate,
        endDate: endDate,
        twoDigit: twoDigit,
      );

  @override
  List<Object?> get props => [
        eventSeries,
      ];
}

String getSimulationSeasonYearsFormattedString({
  required DateTime startDate,
  required DateTime endDate,
  bool twoDigit = false,
}) {
  assert(startDate.isBefore(endDate));
  const lastLettersCount = 2;
  final startYearString = endDate.year.toString();
  final endYearString = endDate.year.toString();
  if (startYearString == endYearString) {
    return twoDigit
        ? startYearString.toString().lastLetters(lastLettersCount)
        : startYearString;
  } else if (endDate.year - startDate.year == 1) {
    return twoDigit
        ? '${startYearString.lastLetters(lastLettersCount)}/${endYearString.lastLetters(lastLettersCount)}'
        : '$startYearString/$endYearString';
  } else {
    return twoDigit
        ? '${startYearString.lastLetters(lastLettersCount)}-${endYearString.lastLetters(lastLettersCount)}'
        : '$startYearString/$endYearString';
  }
}
