import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/to_embrace/competition/high_level_calendar.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_calendar.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class EventSeriesCalendarPresetSerializer
    implements SimulationDbPartSerializer<EventSeriesCalendarPreset> {
  const EventSeriesCalendarPresetSerializer({
    required this.idsRepository,
    required this.lowLevelCalendarSerializer,
    required this.highLevelCalendarSerializer,
  });

  final IdsRepository idsRepository;
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
