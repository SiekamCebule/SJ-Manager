import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class DefaultCompetitionRulesParser
    implements SimulationDbPartParser<DefaultCompetitionRules> {
  const DefaultCompetitionRulesParser({
    required this.idsRepo,
    required this.roundRulesParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<DefaultCompetitionRoundRules> roundRulesParser;

  @override
  DefaultCompetitionRules load(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'individual' => _loadIndividual(json),
      'team' => _loadTeam(json),
      _ => throw ArgumentError(
          'Invalid competition round type: $type (it can be only \'individual\' or \'team\')',
        ),
    };
  }

  DefaultCompetitionRules<Jumper> _loadIndividual(Json json) {
    final rounds =
        _loadRoundsDynamic(json).cast<DefaultIndividualCompetitionRoundRules>();
    return DefaultCompetitionRules(
      rounds: rounds,
    );
  }

  DefaultCompetitionRules<CompetitionTeam> _loadTeam(Json json) {
    final rounds = _loadRoundsDynamic(json).cast<DefaultTeamCompetitionRoundRules>();
    return DefaultCompetitionRules<CompetitionTeam>(
      rounds: rounds,
    );
  }

  List<DefaultCompetitionRoundRules> _loadRoundsDynamic(Json json) {
    final roundsJson = json['rounds'] as List<dynamic>;
    final rounds =
        roundsJson.map((roundJson) => roundRulesParser.load(roundJson)).toList();
    return rounds;
  }
}
