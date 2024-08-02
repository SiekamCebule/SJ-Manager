import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class EventSeriesSetupSerializer implements SimulationDbPartSerializer<EventSeriesSetup> {
  const EventSeriesSetupSerializer({
    required this.idsRepo,
  });

  final IdsRepo idsRepo;

  @override
  Json serialize(EventSeriesSetup facts) {
    return {
      'id': facts.id,
      'name': facts.name,
      'priority': facts.priority,
    };
  }
}
