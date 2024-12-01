import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/concrete/individual_default.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/concrete/team_default.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class ClassificationScoreCreatorSerializer
    implements SimulationDbPartSerializer<ClassificationScoreCreator> {
  const ClassificationScoreCreatorSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  Json serialize(ClassificationScoreCreator creator) {
    if (creator is DefaultIndividualClassificationScoreCreator) {
      return {
        'type': 'default_individual',
      };
    } else if (creator is DefaultTeamClassificationScoreCreator) {
      return {
        'type': 'default_team',
      };
    } /* else if (creator is X) {
    } else if (creator is Y) {
    }*/ // TODO
    else {
      throw UnsupportedError(
        '(Serializing) An unsupported type of ClassificationScoreCreator (${creator.runtimeType})',
      );
    }
  }
}
