import 'dart:async';

import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';
import 'package:sj_manager/utilities/utils/database_io.dart';

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
