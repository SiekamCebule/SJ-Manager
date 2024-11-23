import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class CompetitionRulesProviderParser
    implements SimulationDbPartParser<DefaultCompetitionRulesProvider> {
  const CompetitionRulesProviderParser({
    required this.idsRepository,
    required this.rulesParser,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<DefaultCompetitionRules> rulesParser;

  @override
  FutureOr<DefaultCompetitionRulesProvider> parse(Json json) async {
    final type = json['type'] as String;
    if (type == 'raw') {
      return await rulesParser.parse(json);
    } else if (type == 'fromPreset') {
      return await _loadFromPreset(json);
    } else {
      throw ArgumentError(
        'Invalid competition rules type: $type (It can be only \'raw\' and \'fromPreset\')',
      );
    }
  }

  FutureOr<DefaultCompetitionRulesPreset> _loadFromPreset(Json json) async {
    final presetId = json['presetId'] as String;
    return idsRepository.get<DefaultCompetitionRulesPreset>(presetId);
  }
}
