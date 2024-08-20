import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class EventSeriesSerializer implements SimulationDbPartSerializer<EventSeries> {
  const EventSeriesSerializer({
    required this.idsRepo,
    required this.calendarSerializer,
    required this.factsSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<EventSeriesCalendar> calendarSerializer;
  final SimulationDbPartSerializer<EventSeriesSetup> factsSerializer;

  @override
  Json serialize(EventSeries series) {
    return {
      'calendar': calendarSerializer.serialize(series.calendar),
      'facts': factsSerializer.serialize(series.setup),
    };
  }
}
