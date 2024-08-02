import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class EventSeriesCalendarPresetSerializer
    implements SimulationDbPartSerializer<EventSeriesCalendarPreset> {
  const EventSeriesCalendarPresetSerializer({
    required this.idsRepo,
    required this.calendarSerializer,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartSerializer<EventSeriesCalendar> calendarSerializer;

  @override
  Json serialize(EventSeriesCalendarPreset preset) {
    return {
      'name': preset.name,
      'calendar': calendarSerializer.serialize(preset.calendar),
      if (preset.eventSeries != null) 'eventSeriesId': idsRepo.idOf(preset.eventSeries),
      if (preset.eventSeries == null) 'eventSeriesId': null,
    };
  }
}
