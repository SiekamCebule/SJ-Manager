import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/judges_creator/concrete/default.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class JudgesCreatorLoader implements SimulationDbPartParser<JudgesCreator> {
  const JudgesCreatorLoader({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

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
