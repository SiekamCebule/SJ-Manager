import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/entities_limit.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class EntitiesLimitSerializer implements SimulationDbPartSerializer<EntitiesLimit> {
  const EntitiesLimitSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Json serialize(EntitiesLimit limit) {
    return {
      'type': limit.type.name,
      'count': limit.count,
    };
  }
}
