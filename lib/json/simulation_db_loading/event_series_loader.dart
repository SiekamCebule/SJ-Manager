import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class EventSeriesParser implements SimulationDbPartParser<EventSeries> {
  const EventSeriesParser({
    required this.idsRepo,
    required this.languageCode,
    required this.calendarParser,
    required this.factsParser,
  });

  final ItemsIdsRepo idsRepo;
  final String languageCode;
  final SimulationDbPartParser<EventSeriesCalendar> calendarParser;
  final SimulationDbPartParser<EventSeriesSetup> factsParser;

  @override
  EventSeries parse(Json json) {
    final calendar = calendarParser.parse(json);

    return EventSeries(
      calendar: calendar,
      setup: factsParser.parse(json['facts']),
    );
  }
}
