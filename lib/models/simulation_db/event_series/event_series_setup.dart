import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class EventSeriesSetup {
  const EventSeriesSetup({
    required this.id,
    required this.name,
    required this.priority,
    this.calendarPreset,
  });

  const EventSeriesSetup.empty()
      : this(
          id: '',
          name: const MultilingualString(namesByLanguage: {}),
          priority: 0,
        );

  final String id;
  final MultilingualString name;
  final int priority;
  final EventSeriesCalendarPreset? calendarPreset;
}
