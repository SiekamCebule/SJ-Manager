import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class EventSeriesLoader implements SimulationDbPartLoader<EventSeries> {
  const EventSeriesLoader({
    required this.idsRepo,
    required this.languageCode,
    required this.calendarLoader,
    required this.factsLoader,
  });

  final IdsRepo idsRepo;
  final String languageCode;
  final SimulationDbPartLoader<EventSeriesCalendar> calendarLoader;
  final SimulationDbPartLoader<EventSeriesSetup> factsLoader;

  @override
  EventSeries load(Json json) {
    final calendar = calendarLoader.load(json);

    return EventSeries(
      calendar: calendar,
      setup: factsLoader.load(json['facts']),
    );
  }
}
