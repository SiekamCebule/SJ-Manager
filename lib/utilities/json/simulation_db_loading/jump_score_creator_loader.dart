import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class JumpScoreCreatorLoader implements SimulationDbPartParser<JumpScoreCreator> {
  const JumpScoreCreatorLoader({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  JumpScoreCreator parse(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'default_classic' => DefaultClassicJumpScoreCreator(),
      _ => throw UnsupportedError(
          '(Loading) An unsupported JumpScoreCreatorLoader type ($type)',
        ),
    };
  }
}
