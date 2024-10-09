import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/concrete/team/default_linear.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class CompetitionScoreCreatorSerializer
    implements SimulationDbPartSerializer<CompetitionScoreCreator> {
  const CompetitionScoreCreatorSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Json serialize(CompetitionScoreCreator creator) {
    if (creator is DefaultLinearIndividualCompetitionScoreCreator) {
      return _parseDefaultLinearIndividual(creator);
    } else if (creator is DefaultLinearTeamCompetitionScoreCreator) {
      return _parseDefaultLinearTeam(creator);
    } else {
      throw UnsupportedError(
        '(Parsing) An unsupported CompetitionScoreCreator type (${creator.runtimeType})',
      );
    }
  }

  Json _parseDefaultLinearIndividual(
      DefaultLinearIndividualCompetitionScoreCreator averager) {
    return {
      'type': 'default_linear_individual',
    };
  }

  Json _parseDefaultLinearTeam(DefaultLinearTeamCompetitionScoreCreator averager) {
    return {
      'type': 'default_linear_team',
    };
  }
}
