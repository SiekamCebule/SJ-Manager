import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/competitions/domain/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/features/competitions/domain/utils/jump_score_creator/jump_score_creator.dart';

class JumpScoreCreatorLoader implements SimulationDbPartParser<JumpScoreCreator> {
  const JumpScoreCreatorLoader({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

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
