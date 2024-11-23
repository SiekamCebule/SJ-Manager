import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class TeamCompetitionGroupRulesSerializer
    implements SimulationDbPartSerializer<TeamCompetitionGroupRules> {
  const TeamCompetitionGroupRulesSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  Json serialize(TeamCompetitionGroupRules rules) {
    return {
      'sortStartList': rules.sortStartList,
    };
  }
}
