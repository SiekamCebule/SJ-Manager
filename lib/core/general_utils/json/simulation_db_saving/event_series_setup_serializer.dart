import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_setup.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class EventSeriesSetupSerializer implements SimulationDbPartSerializer<EventSeriesSetup> {
  const EventSeriesSetupSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

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
