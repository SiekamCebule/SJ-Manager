import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/event_series/event_series_setup.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class EventSeriesSetupSerializer implements SimulationDbPartSerializer<EventSeriesSetup> {
  const EventSeriesSetupSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Json serialize(EventSeriesSetup facts) {
    return {
      'id': facts.id,
      'name': facts.multilingualName,
      'priority': facts.priority,
      'relativeMoneyPrize': facts.relativeMoneyPrize.name,
    };
  }
}
