import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class EventSeriesCalendarPresetParser
    implements SimulationDbPartParser<EventSeriesCalendarPreset> {
  const EventSeriesCalendarPresetParser({
    required this.idsRepo,
    required this.calendarParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<EventSeriesCalendar> calendarParser;

  @override
  EventSeriesCalendarPreset load(Json json) {
    return EventSeriesCalendarPreset(
      name: json['name'],
      calendar: calendarParser.load(json['calendar']),
    );
  }
}
