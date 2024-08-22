import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/concrete/team/default_linear.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class CompetitionScoreCreatorLoader
    implements SimulationDbPartParser<CompetitionScoreCreator> {
  const CompetitionScoreCreatorLoader({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  CompetitionScoreCreator load(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'default_linear_individual' => DefaultLinearIndividualCompetitionScoreCreator(),
      'default_linear_team' => DefaultLinearTeamCompetitionScoreCreator(),
      _ => throw UnsupportedError(
          '(Loading) An unsupported CompetitionScoreCreator type ($type)',
        ),
    };
  }
}
