import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/entities_limit.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class EntitiesLimitParser implements SimulationDbPartParser<EntitiesLimit> {
  const EntitiesLimitParser({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  EntitiesLimit parse(Json json) {
    final type = json['type'] as String;
    final count = json['count'] as int;
    return switch (type) {
      'exact' => EntitiesLimit(type: EntitiesLimitType.exact, count: count),
      'soft' => EntitiesLimit(type: EntitiesLimitType.soft, count: count),
      _ => throw ArgumentError(
          'Invalid entities limit type: $type (it can be only \'exact\' and \'soft\')',
        ),
    };
  }
}
