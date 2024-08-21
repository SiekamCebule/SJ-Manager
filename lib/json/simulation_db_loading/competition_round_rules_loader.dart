import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class CompetitionRoundRulesLoader
    implements SimulationDbPartLoader<DefaultCompetitionRoundRules> {
  const CompetitionRoundRulesLoader({
    required this.idsRepo,
    required this.entitiesLimitLoader,
    required this.positionsCreatorLoader,
    required this.teamCompetitionGroupRulesLoader,
    required this.koRoundRulesLoader,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartLoader<EntitiesLimit> entitiesLimitLoader;
  final StandingsPositionsCreatorLoader positionsCreatorLoader;
  final SimulationDbPartLoader<TeamCompetitionGroupRules> teamCompetitionGroupRulesLoader;
  final SimulationDbPartLoader<KoRoundRules> koRoundRulesLoader;

  @override
  DefaultCompetitionRoundRules load(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'individual' => _loadIndividual(json),
      'team' => _loadTeam(json),
      _ => throw ArgumentError(
          'Invalid competition round rules type: $type (it can be only \'individual\' or \'team\')',
        ),
    };
  }

  DefaultCompetitionRoundRules<Jumper> _loadIndividual(Json json) {
    final entitiesLimitJson = json['entitiesLimit'];
    EntitiesLimit? entitiesLimit;
    if (entitiesLimitJson != null) {
      entitiesLimit = entitiesLimitLoader.load(entitiesLimitJson);
    }
    return DefaultIndividualCompetitionRoundRules(
      limit: entitiesLimit,
      bibsAreReassigned: json['bibsAreReassigned'],
      gateCanChange: json['gateCanChange'],
      windAverager: idsRepo.get(json['windAveragerId']),
      inrunLightsEnabled: json['inrunLightsEnabled'],
      dsqEnabled: json['dsqEnabled'],
      positionsCreator: positionsCreatorLoader.load(json['positionsCreator']),
      ruleOf95HsFallEnabled: json['dsqEnabled'],
      judgesCount: json['judgesCount'],
      significantJudgesCount: json['significantJudgesCount'],
      competitionScoreCreator: idsRepo.get(json['competitionScoreCreatorId']),
      jumpScoreCreator: idsRepo.get(json['jumpScoreCreatorId']),
      koRules: koRoundRulesLoader.load(json['koRoundRules']),
    );
  }

  DefaultCompetitionRoundRules<Team> _loadTeam(Json json) {
    final groupsJson = json['groups'] as List<Json>;
    final groups = groupsJson
        .map(
          (json) => teamCompetitionGroupRulesLoader.load(json),
        )
        .toList();

    return DefaultTeamCompetitionRoundRules(
      limit: entitiesLimitLoader.load(json['entitiesLimit']),
      bibsAreReassigned: json['bibsAreReassigned'],
      gateCanChange: json['gateCanChange'],
      windAverager: idsRepo.get(json['windAveragerId']),
      inrunLightsEnabled: json['inrunLightsEnabled'],
      dsqEnabled: json['dsqEnabled'],
      positionsCreator: positionsCreatorLoader.load(json['positionsCreator']),
      ruleOf95HsFallEnabled: json['dsqEnabled'],
      judgesCount: json['judgesCount'],
      significantJudgesCount: json['significantJudgesCount'],
      competitionScoreCreator: idsRepo.get(json['competitionScoreCreatorId']),
      jumpScoreCreator: idsRepo.get(json['jumpScoreCreatorId']),
      groups: groups,
      teamSize: json['teamSize'],
      koRules: koRoundRulesLoader.load(json['koRoundRules']),
    );
  }
}
