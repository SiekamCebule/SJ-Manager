import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/judges_creator/concrete/default.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class JudgesCreatorLoader implements SimulationDbPartParser<JudgesCreator> {
  const JudgesCreatorLoader({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  JudgesCreator parse(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'default' => DefaultJudgesCreator(),
      _ => throw UnsupportedError(
          '(Loading) An unsupported JudgesCreator type ($type)',
        ),
    };
  }
}
