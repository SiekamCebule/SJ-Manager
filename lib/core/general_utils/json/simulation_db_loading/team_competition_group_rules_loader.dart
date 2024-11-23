import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class TeamCompetitionGroupRulesParser
    implements SimulationDbPartParser<TeamCompetitionGroupRules> {
  const TeamCompetitionGroupRulesParser({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  TeamCompetitionGroupRules parse(Json json) {
    return TeamCompetitionGroupRules(
      sortStartList: json['sortStartList'],
    );
  }
}
