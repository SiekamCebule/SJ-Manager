import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/event_series/event_series_facts.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class EventSeriesFactsLoader implements SimulationDbPartLoader<EventSeriesFacts> {
  const EventSeriesFactsLoader({
    required this.idsRepo,
  });

  final IdsRepo idsRepo;

  @override
  EventSeriesFacts load(Json json) {
    return EventSeriesFacts(
      priority: json['priority'],
    );
  }
}
