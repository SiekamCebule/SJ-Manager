import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/domain/entities/simulation/competition/high_level_calendar.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_calendar.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

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
        'type': 'lowLevel',
        'name': preset.name,
        'calendar': lowLevelCalendarSerializer.serialize(preset.calendar),
      };
    } else if (preset is SimpleEventSeriesCalendarPreset) {
      return {
        'type': 'highLevel',
        'name': preset.name,
        'calendar': highLevelCalendarSerializer.serialize(preset.highLevelCalendar),
      };
    } else {
      throw ArgumentError(
          '(Serializing) An invalid EventSeriesCalendarPreset\'s type: ${preset.runtimeType}');
    }
  }
}
