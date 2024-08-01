import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/entities_limit.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class EntitiesLimitLoader implements SimulationDbPartLoader<EntitiesLimit> {
  const EntitiesLimitLoader({
    required this.idsRepo,
  });

  final IdsRepo idsRepo;

  @override
  EntitiesLimit load(Json json) {
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
