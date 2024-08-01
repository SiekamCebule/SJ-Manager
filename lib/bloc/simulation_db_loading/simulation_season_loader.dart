import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class SimulationSeasonLoader implements SimulationDbPartLoader<SimulationSeason> {
  const SimulationSeasonLoader({
    required this.idsRepo,
    required this.eventSeriesLoader,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartLoader<EventSeries> eventSeriesLoader;

  @override
  SimulationSeason load(Json json) {
    final eventSeriesJson = json['eventSeries'] as List<Json>;
    final eventSeries = eventSeriesJson.map((json) {
      return eventSeriesLoader.load(json);
    });
    return SimulationSeason(
      eventSeries: eventSeries.toList(),
    );
  }
}
