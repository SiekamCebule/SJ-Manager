import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/wind_averager/wind_averager.dart';
import 'package:sj_manager/models/simulation_db/standings/score/typedefs.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class CompetitionRoundRulesParser
    implements SimulationDbPartParser<DefaultCompetitionRoundRules> {
  const CompetitionRoundRulesParser({
    required this.idsRepo,
    required this.entitiesLimitParser,
    required this.positionsCreatorParser,
    required this.teamCompetitionGroupRulesParser,
    required this.koRoundRulesParser,
    required this.windAveragerParser,
    required this.judgesCreatorParser,
    required this.competitionScoreCreatorParser,
    required this.jumpScoreCreatorParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<EntitiesLimit> entitiesLimitParser;
  final StandingsPositionsCreatorParser positionsCreatorParser;
  final SimulationDbPartParser<TeamCompetitionGroupRules> teamCompetitionGroupRulesParser;
  final SimulationDbPartParser<KoRoundRules> koRoundRulesParser;
  final SimulationDbPartParser<WindAverager> windAveragerParser;
  final SimulationDbPartParser<JudgesCreator> judgesCreatorParser;
  final SimulationDbPartParser<CompetitionScoreCreator> competitionScoreCreatorParser;
  final SimulationDbPartParser<JumpScoreCreator> jumpScoreCreatorParser;

  @override
  DefaultCompetitionRoundRules parse(Json json) {
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
    final entitiesLimitJson = json['limit'];
    EntitiesLimit? entitiesLimit;
    if (entitiesLimitJson != null) {
      entitiesLimit = entitiesLimitParser.parse(entitiesLimitJson);
    }
    final competitionScoreCreator =
        competitionScoreCreatorParser.parse(json['competitionScoreCreator']);
    if (competitionScoreCreator is CompetitionScoreCreator<CompetitionScore<Jumper>> ==
        false) {
      throw ArgumentError(
        '(Parsing) The loaded competition score creator type is not a valid one for individual competition rules (${competitionScoreCreator.runtimeType})',
      );
    }
    final koRulesJson = json['koRoundRules'];

    return DefaultIndividualCompetitionRoundRules(
      limit: entitiesLimit,
      bibsAreReassigned: json['bibsAreReassigned'],
      startlistIsSorted: json['startlistIsSorted'],
      gateCanChange: json['gateCanChange'],
      gateCompensationsEnabled: json['gateCompensationsEnabled'],
      windCompensationsEnabled: json['windCompensationsEnabled'],
      windAverager: windAveragerParser.parse(json['windAverager']),
      inrunLightsEnabled: json['inrunLightsEnabled'],
      dsqEnabled: json['dsqEnabled'],
      positionsCreator: positionsCreatorParser.parse(json['positionsCreator']),
      ruleOf95HsFallEnabled: json['dsqEnabled'],
      judgesCount: json['judgesCount'],
      judgesCreator: judgesCreatorParser.parse(json['judgesCreator']),
      significantJudgesCount: json['significantJudgesCount'],
      competitionScoreCreator:
          competitionScoreCreator as CompetitionScoreCreator<CompetitionJumperScore>,
      jumpScoreCreator: jumpScoreCreatorParser.parse(json['jumpScoreCreator']),
      koRules: koRulesJson != null ? koRoundRulesParser.parse(koRulesJson) : null,
    );
  }

  DefaultCompetitionRoundRules<Team> _loadTeam(Json json) {
    final entitiesLimitJson = json['limit'];
    EntitiesLimit? entitiesLimit;
    if (entitiesLimitJson != null) {
      entitiesLimit = entitiesLimitParser.parse(entitiesLimitJson);
    }

    final groupsJson = (json['groups'] as List).cast<Json>();
    final groups = groupsJson
        .map(
          (json) => teamCompetitionGroupRulesParser.parse(json),
        )
        .toList();

    final competitionScoreCreator =
        competitionScoreCreatorParser.parse(json['competitionScoreCreator']);
    if (competitionScoreCreator is CompetitionScoreCreator<CompetitionTeamScore> ==
        false) {
      throw ArgumentError(
        '(Parsing) The loaded competition score creator type is not a valid one for team competition rules (${competitionScoreCreator.runtimeType})',
      );
    }
    final koRulesJson = json['koRoundRules'];

    return DefaultTeamCompetitionRoundRules(
      limit: entitiesLimit,
      bibsAreReassigned: json['bibsAreReassigned'],
      startlistIsSorted: json['startlistIsSorted'],
      gateCanChange: json['gateCanChange'],
      gateCompensationsEnabled: json['gateCompensationsEnabled'],
      windCompensationsEnabled: json['windCompensationsEnabled'],
      windAverager: windAveragerParser.parse(json['windAverager']),
      inrunLightsEnabled: json['inrunLightsEnabled'],
      dsqEnabled: json['dsqEnabled'],
      positionsCreator: positionsCreatorParser.parse(json['positionsCreator']),
      ruleOf95HsFallEnabled: json['dsqEnabled'],
      judgesCount: json['judgesCount'],
      judgesCreator: judgesCreatorParser.parse(json['judgesCreator']),
      significantJudgesCount: json['significantJudgesCount'],
      competitionScoreCreator:
          competitionScoreCreator as CompetitionScoreCreator<CompetitionTeamScore>,
      jumpScoreCreator: jumpScoreCreatorParser.parse(json['jumpScoreCreator']),
      groups: groups,
      koRules: koRulesJson != null ? koRoundRulesParser.parse(koRulesJson) : null,
    );
  }
}
