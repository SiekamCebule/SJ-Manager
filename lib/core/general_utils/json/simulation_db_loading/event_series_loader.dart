import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_calendar.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_setup.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class EventSeriesParser implements SimulationDbPartParser<EventSeries> {
  const EventSeriesParser({
    required this.idsRepository,
    required this.calendarParser,
    required this.setupParser,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<EventSeriesCalendar> calendarParser;
  final SimulationDbPartParser<EventSeriesSetup> setupParser;

  @override
  FutureOr<EventSeries> parse(Json json) async {
    final calendar = await calendarParser.parse(json['calendar']);

    return EventSeries(
      calendar: calendar,
      setup: await setupParser.parse(json['facts']),
    );
  }
}
