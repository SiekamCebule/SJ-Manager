import 'dart:async';

import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/event_series/event_series.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/database_io.dart';

class SimulationSeasonParser implements SimulationDbPartParser<SimulationSeason> {
  const SimulationSeasonParser({
    required this.idsRepo,
    required this.eventSeriesParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<EventSeries> eventSeriesParser;

  @override
  Future<SimulationSeason> parse(Json json) async {
    final eventSeriesMap = await parseItemsMap(
      json: json['eventSeries'],
      fromJson: (json) async {
        return await _parseEventSeries(json);
      },
    );
    final eventSeries = eventSeriesMap.getOrderedItems();
    idsRepo.registerFromLoadedItemsMap(eventSeriesMap);

    return SimulationSeason(
      eventSeries: eventSeries,
    );
  }

  FutureOr<EventSeries> _parseEventSeries(Json json) async {
    return await eventSeriesParser.parse(json);
  }
}
