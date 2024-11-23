import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/database_io.dart';

class SimulationSeasonParser implements SimulationDbPartParser<SimulationSeason> {
  const SimulationSeasonParser({
    required this.idsRepository,
    required this.eventSeriesParser,
  });

  final IdsRepository idsRepository;
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
    idsRepository.registerFromLoadedItemsMap(eventSeriesMap);

    return SimulationSeason(
      eventSeries: eventSeries,
    );
  }

  FutureOr<EventSeries> _parseEventSeries(Json json) async {
    return await eventSeriesParser.parse(json);
  }
}
