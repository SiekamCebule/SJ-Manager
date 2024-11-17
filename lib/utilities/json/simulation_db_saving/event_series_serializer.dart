import 'dart:async';

import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_calendar.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_setup.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class EventSeriesSerializer implements SimulationDbPartSerializer<EventSeries> {
  const EventSeriesSerializer({
    required this.idsRepo,
    required this.calendarSerializer,
    required this.setupSerializer,
  });

  final ItemsIdsRepo idsRepo;
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
