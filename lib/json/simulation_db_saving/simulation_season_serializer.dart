import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class SimulationSeasonSerializer implements SimulationDbPartSerializer<SimulationSeason> {
  const SimulationSeasonSerializer({
    required this.idsRepo,
    required this.eventSeriesSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<EventSeries> eventSeriesSerializer;

  @override
  Json serialize(SimulationSeason season) {
    final eventSeriesJson = season.eventSeries.map((eventSeries) {
      return eventSeriesSerializer.serialize(eventSeries);
    }).toList();
    return {
      'eventSeries': eventSeriesJson,
    };
  }
}
