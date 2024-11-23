import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/database_io.dart';

class SimulationSeasonSerializer implements SimulationDbPartSerializer<SimulationSeason> {
  const SimulationSeasonSerializer({
    required this.idsRepository,
    required this.eventSeriesSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<EventSeries> eventSeriesSerializer;

  @override
  Future<Json> serialize(SimulationSeason season) async {
    final eventSeriesJson = await serializeItemsMap(
      items: season.eventSeries,
      idsRepository: idsRepository,
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
