import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/concrete/individual/default_linear.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/concrete/team/default_linear.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class CompetitionScoreCreatorSerializer
    implements SimulationDbPartSerializer<CompetitionScoreCreator> {
  const CompetitionScoreCreatorSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

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
