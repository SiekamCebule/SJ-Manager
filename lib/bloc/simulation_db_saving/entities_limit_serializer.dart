import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/entities_limit.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class EntitiesLimitSerializer implements SimulationDbPartSerializer<EntitiesLimit> {
  const EntitiesLimitSerializer({
    required this.idsRepo,
  });

  final IdsRepo idsRepo;

  @override
  Json serialize(EntitiesLimit limit) {
    return {
      'type': limit.type.name,
      'count': limit.count,
    };
  }
}
