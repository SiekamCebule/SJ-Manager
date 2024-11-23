import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/entities_limit.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class EntitiesLimitSerializer implements SimulationDbPartSerializer<EntitiesLimit> {
  const EntitiesLimitSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  Json serialize(EntitiesLimit limit) {
    return {
      'type': limit.type.name,
      'count': limit.count,
    };
  }
}
