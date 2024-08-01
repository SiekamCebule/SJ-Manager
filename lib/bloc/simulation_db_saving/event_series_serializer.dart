import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_facts.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class EventSeriesSerializer implements SimulationDbPartSerializer<EventSeries> {
  const EventSeriesSerializer({
    required this.idsRepo,
    required this.calendarSerializer,
    required this.factsSerializer,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartSerializer<EventSeriesCalendar> calendarSerializer;
  final SimulationDbPartSerializer<EventSeriesFacts> factsSerializer;

  @override
  Json serialize(EventSeries series) {
    return {
      'name': series.name.namesByLanguage,
      'calendar': calendarSerializer.serialize(series.calendar),
      'facts': factsSerializer.serialize(series.facts),
    };
  }
}
