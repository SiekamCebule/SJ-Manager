import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class TeamCompetitionGroupRulesSerializer
    implements SimulationDbPartSerializer<TeamCompetitionGroupRules> {
  const TeamCompetitionGroupRulesSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Json serialize(TeamCompetitionGroupRules rules) {
    return {
      'sortStartList': rules.sortStartList,
    };
  }
}
