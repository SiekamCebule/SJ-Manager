import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class JumpScoreCreatorSerializer implements SimulationDbPartSerializer<JumpScoreCreator> {
  const JumpScoreCreatorSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Json serialize(JumpScoreCreator creator) {
    if (creator is DefaultClassicJumpScoreCreator) {
      return _parseDefaultClassic(creator);
    } else {
      throw UnsupportedError(
        '(Parsing) An unsupported JumpScoreCreator type (${creator.runtimeType})',
      );
    }
  }

  Json _parseDefaultClassic(JumpScoreCreator creator) {
    return {
      'type': 'default_classic',
    };
  }
}
