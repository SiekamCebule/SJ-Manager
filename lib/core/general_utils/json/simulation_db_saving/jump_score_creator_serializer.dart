import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class JumpScoreCreatorSerializer implements SimulationDbPartSerializer<JumpScoreCreator> {
  const JumpScoreCreatorSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

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
