import 'dart:async';

import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';
import 'package:sj_manager/utilities/utils/database_io.dart';

class SimulationSeasonSerializer implements SimulationDbPartSerializer<SimulationSeason> {
  const SimulationSeasonSerializer({
    required this.idsRepo,
    required this.eventSeriesSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<EventSeries> eventSeriesSerializer;

  @override
  Future<Json> serialize(SimulationSeason season) async {
    final eventSeriesJson = await serializeItemsMap(
      items: season.eventSeries,
      idsRepo: idsRepo,
      toJson: (eventSeries) async => await _serializeSingleEventSeries(eventSeries),
    );

    return {
      'eventSeries': eventSeriesJson,
    };
  }

  FutureOr<Map<String, dynamic>> _serializeSingleEventSeries(
      EventSeries eventSeries) async {
    return await eventSeriesSerializer.serialize(eventSeries);
  }
}
