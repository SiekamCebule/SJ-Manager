import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class TeamCompetitionGroupRulesParser
    implements SimulationDbPartParser<TeamCompetitionGroupRules> {
  const TeamCompetitionGroupRulesParser({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  TeamCompetitionGroupRules parse(Json json) {
    return TeamCompetitionGroupRules(
      sortStartList: json['sortStartList'],
    );
  }
}
