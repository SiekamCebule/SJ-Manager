import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_provider.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class CompetitionRulesProviderSerializer
    implements SimulationDbPartSerializer<CompetitionRulesProvider> {
  const CompetitionRulesProviderSerializer({
    required this.idsRepo,
    required this.roundRulesSerializer,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartSerializer<CompetitionRoundRules> roundRulesSerializer;

  @override
  Json serialize(CompetitionRulesProvider rulesProvider) {
    if (rulesProvider is CompetitionRules) {
      return _serializeRaw(rulesProvider);
    } else if (rulesProvider is CompetitionRulesPreset) {
      return _serializePreset(rulesProvider);
    } else {
      throw UnsupportedError(
          'Unsupported CompetitionRulesProvider type: ${rulesProvider.runtimeType}');
    }
  }

  Json _serializeRaw(CompetitionRules rules) {
    final roundsJson = rules.rounds.map((json) {
      return roundRulesSerializer.serialize(json);
    });
    return {
      'type': 'raw',
      'rounds': roundsJson,
    };
  }

  Json _serializePreset(CompetitionRulesPreset rulesPreset) {
    return {
      'type': 'fromPreset',
      'presetId': idsRepo.idOf(rulesPreset.competitionRules),
    };
  }
}
