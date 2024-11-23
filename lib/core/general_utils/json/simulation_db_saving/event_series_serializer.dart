import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_calendar.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_setup.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class EventSeriesSerializer implements SimulationDbPartSerializer<EventSeries> {
  const EventSeriesSerializer({
    required this.idsRepository,
    required this.calendarSerializer,
    required this.setupSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<EventSeriesCalendar> calendarSerializer;
  final SimulationDbPartSerializer<EventSeriesSetup> setupSerializer;

  @override
  FutureOr<Json> serialize(EventSeries series) async {
    return {
      'calendar': await calendarSerializer.serialize(series.calendar),
      'facts': setupSerializer.serialize(series.setup),
    };
  }
}
