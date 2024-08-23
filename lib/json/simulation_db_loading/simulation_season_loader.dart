import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class SimulationSeasonParser implements SimulationDbPartParser<SimulationSeason> {
  const SimulationSeasonParser({
    required this.idsRepo,
    required this.eventSeriesParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<EventSeries> eventSeriesParser;

  @override
  SimulationSeason parse(Json json) {
    final eventSeriesJson = json['eventSeries'] as List<Json>;
    final eventSeries = eventSeriesJson.map((json) {
      return eventSeriesParser.parse(json);
    });
    return SimulationSeason(
      eventSeries: eventSeries.toList(),
    );
  }
}
