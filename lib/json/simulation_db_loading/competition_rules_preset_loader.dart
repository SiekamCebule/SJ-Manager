import 'dart:async';

import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class CompetitionRulesPresetParser
    implements SimulationDbPartParser<DefaultCompetitionRulesPreset> {
  const CompetitionRulesPresetParser({
    required this.idsRepo,
    required this.rulesParser,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartParser<DefaultCompetitionRules> rulesParser;

  @override
  FutureOr<DefaultCompetitionRulesPreset> parse(Json json) async {
    return DefaultCompetitionRulesPreset(
      name: json['name'],
      rules: await rulesParser.parse(json['rules']),
    );
  }
}
