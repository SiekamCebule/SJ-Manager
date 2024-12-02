import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/competitions/domain/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/judges_creator/specific/default_judges_creator.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class JudgesCreatorSerializer implements SimulationDbPartSerializer<JudgesCreator> {
  const JudgesCreatorSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  Json serialize(JudgesCreator creator) {
    if (creator is DefaultJudgesCreator) {
      return _parseDefault(creator);
    } else {
      throw UnsupportedError(
        '(Parsing) An unsupported JudgesCreator type (${creator.runtimeType})',
      );
    }
  }

  Json _parseDefault(DefaultJudgesCreator creator) {
    return {
      'type': 'default',
    };
  }
}
