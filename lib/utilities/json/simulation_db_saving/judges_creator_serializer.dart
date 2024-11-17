import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/judges_creator/concrete/default.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class JudgesCreatorSerializer implements SimulationDbPartSerializer<JudgesCreator> {
  const JudgesCreatorSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

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
