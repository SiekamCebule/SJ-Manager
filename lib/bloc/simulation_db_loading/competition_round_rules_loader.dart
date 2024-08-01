import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/individual_competition_round_rules.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/team_competition_round_rules.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/models/db/team/team.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class CompetitionRoundRulesLoader
    implements SimulationDbPartLoader<CompetitionRoundRules> {
  const CompetitionRoundRulesLoader({
    required this.idsRepo,
    required this.entitiesLimitLoader,
    required this.positionsCreatorLoader,
    required this.teamCompetitionGroupRulesLoader,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartLoader<EntitiesLimit> entitiesLimitLoader;
  final SimulationDbPartLoader<StandingsPositionsCreator> positionsCreatorLoader;
  final SimulationDbPartLoader<TeamCompetitionGroupRules> teamCompetitionGroupRulesLoader;

  @override
  CompetitionRoundRules load(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'individual' => _loadIndividual(json),
      'team' => _loadTeam(json),
      _ => throw ArgumentError(
          'Invalid competition round rules type: $type (it can be only \'individual\' or \'team\')',
        ),
    };
  }

  CompetitionRoundRules<Jumper> _loadIndividual(Json json) {
    final entitiesLimitJson = json['entitiesLimit'];
    EntitiesLimit? entitiesLimit;
    if (entitiesLimitJson != null) {
      entitiesLimit = entitiesLimitLoader.load(entitiesLimitJson);
    }
    return IndividualCompetitionRoundRules(
      limit: entitiesLimit,
      bibsAreReassigned: json['bibsAreReassigned'],
      gateCanChange: json['gateCanChange'],
      windAverager: idsRepo.get(json['windAveragerId']),
      inrunLightsEnabled: json['inrunLightsEnabled'],
      dsqEnabled: json['dsqEnabled'],
      positionsCreator: positionsCreatorLoader.load(json['positionsCreator']),
      canBeCancelledByWind: json['dsqEnabled'],
      ruleOf95HsFallEnabled: json['dsqEnabled'],
      judgesCount: json['judgesCount'],
      competitionScoreCreator: idsRepo.get(json['competitionScoreCreatorId']),
      jumpScoreCreator: idsRepo.get(json['jumpScoreCreatorId']),
      significantJudgesChooser: idsRepo.get(json['significantJudgesChooserId']),
    );
  }

  CompetitionRoundRules<Team> _loadTeam(Json json) {
    final groupsJson = json['groups'] as List<Json>;
    final groups = groupsJson
        .map(
          (json) => teamCompetitionGroupRulesLoader.load(json),
        )
        .toList();

    return TeamCompetitionRoundRules(
      limit: entitiesLimitLoader.load(json['entitiesLimit']),
      bibsAreReassigned: json['bibsAreReassigned'],
      gateCanChange: json['gateCanChange'],
      windAverager: idsRepo.get(json['windAveragerId']),
      inrunLightsEnabled: json['inrunLightsEnabled'],
      dsqEnabled: json['dsqEnabled'],
      positionsCreator: positionsCreatorLoader.load(json['positionsCreator']),
      canBeCancelledByWind: json['dsqEnabled'],
      ruleOf95HsFallEnabled: json['dsqEnabled'],
      judgesCount: json['judgesCount'],
      competitionScoreCreator: idsRepo.get(json['competitionScoreCreatorId']),
      jumpScoreCreator: idsRepo.get(json['jumpScoreCreatorId']),
      significantJudgesChooser: idsRepo.get(json['significantJudgesChooserId']),
      groups: groups,
      teamSize: json['teamSize'],
    );
  }
}
