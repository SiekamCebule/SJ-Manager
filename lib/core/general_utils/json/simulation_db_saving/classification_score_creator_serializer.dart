import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/simple/simple_classification_jumper_score_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/simple/simple_classification_team_score_creator.dart';

class ClassificationScoreCreatorSerializer
    implements SimulationDbPartSerializer<ClassificationScoreCreator> {
  const ClassificationScoreCreatorSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  Json serialize(ClassificationScoreCreator creator) {
    if (creator is SimpleClassificationJumperScoreCreator) {
      return {
        'type': 'simple_jumper',
      };
    } else if (creator is SimpleClassificationTeamScoreCreator) {
      return {
        'type': 'simple_team',
      };
    } else {
      throw UnsupportedError(
        '(Serializing) An unsupported type of ClassificationScoreCreator (${creator.runtimeType})',
      );
    }
  }
}
