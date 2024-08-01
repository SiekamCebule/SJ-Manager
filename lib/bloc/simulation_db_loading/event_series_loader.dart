import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/models/db/event_series/event_series.dart';
import 'package:sj_manager/models/db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/db/event_series/event_series_facts.dart';
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
  final SimulationDbPartLoader<EventSeriesFacts> factsLoader;

  @override
  EventSeries load(Json json) {
    final name = stringFromMultilingualJson(json,
        languageCode: languageCode, parameterName: 'name');
    final id = json['id'] as String;
    final calendar = calendarLoader.load(json);

    return EventSeries(
      id: id,
      name: name,
      calendar: calendar,
      facts: factsLoader.load(json['facts']),
    );
  }
}
