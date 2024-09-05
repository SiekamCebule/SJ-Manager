import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_records_to_calendar.dart';
import 'package:sj_manager/models/simulation_db/competition/high_level_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';

abstract class EventSeriesCalendarPreset {
  const EventSeriesCalendarPreset();

  String get name;
  EventSeriesCalendar get calendar;
}

class SimpleEventSeriesCalendarPreset extends EventSeriesCalendarPreset {
  const SimpleEventSeriesCalendarPreset({
    required this.name,
    required this.highLevelCalendar,
  });

  const SimpleEventSeriesCalendarPreset.empty()
      : this(
          name: '',
          highLevelCalendar: const HighLevelCalendar.empty(),
        );

  @override
  final String name;

  final HighLevelCalendar<CalendarMainCompetitionRecord> highLevelCalendar;

  @override
  EventSeriesCalendar get calendar {
    final calendar =
        CalendarMainCompetitionRecordsToCalendarConverter().convert(highLevelCalendar);
    return calendar;
  }
}

class LowLevelEventSeriesCalendarPreset extends EventSeriesCalendarPreset {
  const LowLevelEventSeriesCalendarPreset({
    required this.name,
    required this.calendar,
  });

  const LowLevelEventSeriesCalendarPreset.empty()
      : this(
          name: '',
          calendar: const EventSeriesCalendar.empty(),
        );

  @override
  final String name;

  @override
  final EventSeriesCalendar calendar;
}
