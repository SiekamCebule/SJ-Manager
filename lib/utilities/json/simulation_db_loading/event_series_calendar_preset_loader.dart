import 'dart:async';

import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/simulation/competition/calendar_records/calendar_main_competition_record.dart';

import 'package:sj_manager/data/models/simulation/competition/high_level_calendar.dart';
import 'package:sj_manager/data/models/simulation/event_series/event_series_calendar.dart';
import 'package:sj_manager/data/models/simulation/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class EventSeriesCalendarPresetParser
    implements SimulationDbPartParser<EventSeriesCalendarPreset> {
  const EventSeriesCalendarPresetParser({
    required this.idsRepo,
    required this.lowLevelCalendarParser,
    required this.highLevelCalendarParser,
  });

  final ItemsIdsRepo idsRepo;
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
