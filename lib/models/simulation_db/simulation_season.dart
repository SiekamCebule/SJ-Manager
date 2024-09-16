import 'package:equatable/equatable.dart';
import 'package:sj_manager/extensions/string.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';

class SimulationSeason with EquatableMixin {
  const SimulationSeason({
    required this.eventSeries,
  });

  final List<EventSeries> eventSeries;

  // TODO:
  DateTime get startDate {
    throw UnimplementedError();
  }

  DateTime get endDate {
    throw UnimplementedError();
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
  List<Object?> get props => [];
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
