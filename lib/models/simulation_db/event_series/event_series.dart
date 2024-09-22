import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';

class EventSeries with EquatableMixin {
  const EventSeries({
    required this.calendar,
    required this.setup,
  });

  const EventSeries.empty()
      : this(
          calendar: const EventSeriesCalendar.empty(),
          setup: const EventSeriesSetup.empty(),
        );

  final EventSeriesCalendar calendar;
  final EventSeriesSetup setup;

  DateTime get startDate => calendar.competitions.first.date;
  DateTime get endDate => calendar.competitions.last.date;

  @override
  List<Object?> get props => [
        calendar,
        setup,
      ];
}
