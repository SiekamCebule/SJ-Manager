import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/competition_team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class DefaultCompetitionRulesParser
    implements SimulationDbPartParser<DefaultCompetitionRules> {
  const DefaultCompetitionRulesParser({
    required this.idsRepository,
    required this.roundRulesParser,
  });

  final IdsRepository idsRepository;
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

  FutureOr<DefaultCompetitionRules<JumperDbRecord>> _loadIndividual(Json json) async {
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
