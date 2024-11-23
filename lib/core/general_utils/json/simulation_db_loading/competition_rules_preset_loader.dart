import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class CompetitionRulesPresetParser
    implements SimulationDbPartParser<DefaultCompetitionRulesPreset> {
  const CompetitionRulesPresetParser({
    required this.idsRepository,
    required this.rulesParser,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<DefaultCompetitionRules> rulesParser;

  @override
  FutureOr<DefaultCompetitionRulesPreset> parse(Json json) async {
    return DefaultCompetitionRulesPreset(
      name: json['name'],
      rules: await rulesParser.parse(json['rules']),
    );
  }
}
