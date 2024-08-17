import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class TeamCompetitionGroupRulesSerializer
    implements SimulationDbPartSerializer<TeamCompetitionGroupRules> {
  const TeamCompetitionGroupRulesSerializer({
    required this.idsRepo,
  });

  final IdsRepo idsRepo;

  @override
  Json serialize(TeamCompetitionGroupRules rules) {
    return {
      'sortStartList': rules.sortStartList,
    };
  }
}
