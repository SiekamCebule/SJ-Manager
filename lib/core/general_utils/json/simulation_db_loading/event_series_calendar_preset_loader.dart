import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/calendar_records/calendar_main_competition_record.dart';

import 'package:sj_manager/to_embrace/competition/high_level_calendar.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_calendar.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class EventSeriesCalendarPresetParser
    implements SimulationDbPartParser<EventSeriesCalendarPreset> {
  const EventSeriesCalendarPresetParser({
    required this.idsRepository,
    required this.lowLevelCalendarParser,
    required this.highLevelCalendarParser,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<EventSeriesCalendar> lowLevelCalendarParser;
  final SimulationDbPartParser<HighLevelCalendar<CalendarMainCompetitionRecord>>
      highLevelCalendarParser;

  @override
  FutureOr<EventSeriesCalendarPreset> parse(Json json) async {
    final type = json['type'] as String;
    return switch (type) {
      'lowLevel' => LowLevelEventSeriesCalendarPreset(
          name: json['name'],
          calendar: await lowLevelCalendarParser.parse(
            json['calendar'],
          ),
        ),
      'highLevel' => SimpleEventSeriesCalendarPreset(
          name: json['name'],
          highLevelCalendar: await highLevelCalendarParser.parse(
            json['calendar'],
          ),
        ),
      _ => throw ArgumentError(
          '(Parsig) An invalid EventSeriesCalendarPreset\'s type: $type'),
    };
  }
}
