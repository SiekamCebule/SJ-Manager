import 'dart:async';

import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
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
  FutureOr<DefaultCompetitionRules> parse(Json json) async {
    final type = json['type'] as String;
    return switch (type) {
      'individual' => await _loadIndividual(json),
      'team' => await _loadTeam(json),
      _ => throw ArgumentError(
          'Invalid competition round type: $type (it can be only \'individual\' or \'team\')',
        ),
    };
  }

  FutureOr<DefaultCompetitionRules<Jumper>> _loadIndividual(Json json) async {
    final rounds =
        (await _loadRoundsDynamic(json)).cast<DefaultIndividualCompetitionRoundRules>();
    return DefaultCompetitionRules(
      rounds: rounds,
    );
  }

  FutureOr<DefaultCompetitionRules<CompetitionTeam>> _loadTeam(Json json) async {
    final rounds =
        (await _loadRoundsDynamic(json)).cast<DefaultTeamCompetitionRoundRules>();
    return DefaultCompetitionRules<CompetitionTeam>(
      rounds: rounds,
    );
  }

  FutureOr<List<DefaultCompetitionRoundRules>> _loadRoundsDynamic(Json json) async {
    final roundsJson = json['rounds'] as List<dynamic>;
    final rounds = await Future.wait(
      roundsJson.map((roundJson) async => await roundRulesParser.parse(roundJson)),
    );

    return rounds;
  }
}
