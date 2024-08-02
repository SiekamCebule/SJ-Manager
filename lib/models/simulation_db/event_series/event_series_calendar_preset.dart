import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';

class EventSeriesCalendarPreset {
  const EventSeriesCalendarPreset({
    required this.name,
    required this.calendar,
    this.eventSeries,
  });

  const EventSeriesCalendarPreset.empty()
      : this(
          name: '',
          calendar: const EventSeriesCalendar.empty(),
          eventSeries: null,
        );

  final String name;
  final EventSeriesCalendar calendar;
  final EventSeriesSetup? eventSeries;
}
