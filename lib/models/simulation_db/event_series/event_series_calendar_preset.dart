import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';

class EventSeriesCalendarPreset {
  const EventSeriesCalendarPreset({
    required this.name,
    required this.calendar,
  });

  const EventSeriesCalendarPreset.empty()
      : this(
          name: '',
          calendar: const EventSeriesCalendar.empty(),
        );

  final String name;
  final EventSeriesCalendar calendar;

  EventSeriesCalendarPreset copyWith({
    String? name,
    EventSeriesCalendar? calendar,
  }) {
    return EventSeriesCalendarPreset(
      name: name ?? this.name,
      calendar: calendar ?? this.calendar,
    );
  }
}
