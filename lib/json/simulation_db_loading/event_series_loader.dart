import 'dart:async';

import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class EventSeriesParser implements SimulationDbPartParser<EventSeries> {
  const EventSeriesParser({
    required this.idsRepo,
    required this.calendarParser,
    required this.setupParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<EventSeriesCalendar> calendarParser;
  final SimulationDbPartParser<EventSeriesSetup> setupParser;

  @override
  FutureOr<EventSeries> parse(Json json) async {
    final calendar = await calendarParser.parse(json);

    return EventSeries(
      calendar: calendar,
      setup: await setupParser.parse(json['facts']),
    );
  }
}
