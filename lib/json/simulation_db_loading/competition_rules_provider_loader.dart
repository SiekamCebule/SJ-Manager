import 'dart:async';

import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class CompetitionRulesProviderParser
    implements SimulationDbPartParser<DefaultCompetitionRulesProvider> {
  const CompetitionRulesProviderParser({
    required this.idsRepo,
    required this.rulesParser,
  });

  final ItemsIdsRepo idsRepo;
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
    return idsRepo.get<DefaultCompetitionRulesPreset>(presetId);
  }
}
