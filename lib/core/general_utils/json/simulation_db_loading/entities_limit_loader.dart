import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/entities_limit.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class EntitiesLimitParser implements SimulationDbPartParser<EntitiesLimit> {
  const EntitiesLimitParser({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

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
