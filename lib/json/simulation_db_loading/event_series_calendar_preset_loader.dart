import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class EventSeriesCalendarPresetLoader
    implements SimulationDbPartLoader<EventSeriesCalendarPreset> {
  const EventSeriesCalendarPresetLoader({
    required this.idsRepo,
    required this.calendarLoader,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartLoader<EventSeriesCalendar> calendarLoader;

  @override
  EventSeriesCalendarPreset load(Json json) {
    var eventSeriesId = json['eventSeriesId'] as String?;
    return EventSeriesCalendarPreset(
      name: json['name'],
      calendar: calendarLoader.load(json['calendar']),
      eventSeries: eventSeriesId != null ? idsRepo.get(eventSeriesId) : null,
    );
  }
}
