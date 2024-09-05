import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/competition/high_level_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class EventSeriesCalendarPresetSerializer
    implements SimulationDbPartSerializer<EventSeriesCalendarPreset> {
  const EventSeriesCalendarPresetSerializer({
    required this.idsRepo,
    required this.lowLevelCalendarSerializer,
    required this.highLevelCalendarSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<EventSeriesCalendar> lowLevelCalendarSerializer;
  final SimulationDbPartSerializer<HighLevelCalendar<CalendarMainCompetitionRecord>>
      highLevelCalendarSerializer;

  @override
  Json serialize(EventSeriesCalendarPreset preset) {
    if (preset is LowLevelEventSeriesCalendarPreset) {
      return {
        'name': preset.name,
        'calendar': lowLevelCalendarSerializer.serialize(preset.calendar),
      };
    } else if (preset is SimpleEventSeriesCalendarPreset) {
      return {
        'name': preset.name,
        'calendar': highLevelCalendarSerializer.serialize(preset.highLevelCalendar),
      };
    } else {
      throw ArgumentError(
          '(Serializing) An invalid EventSeriesCalendarPreset\'s type: ${preset.runtimeType}');
    }
  }
}
