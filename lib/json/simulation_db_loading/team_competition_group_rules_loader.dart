import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class TeamCompetitionGroupRulesLoader
    implements SimulationDbPartLoader<TeamCompetitionGroupRules> {
  const TeamCompetitionGroupRulesLoader({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  TeamCompetitionGroupRules load(Json json) {
    return TeamCompetitionGroupRules(
      sortStartList: json['sortStartList'],
    );
  }
}
