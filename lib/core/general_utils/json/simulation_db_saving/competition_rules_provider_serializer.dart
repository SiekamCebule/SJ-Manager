import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class CompetitionRulesProviderSerializer
    implements SimulationDbPartSerializer<DefaultCompetitionRulesProvider> {
  const CompetitionRulesProviderSerializer({
    required this.idsRepository,
    required this.rulesSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<DefaultCompetitionRules> rulesSerializer;

  @override
  Json serialize(DefaultCompetitionRulesProvider rulesProvider) {
    if (rulesProvider is DefaultCompetitionRules) {
      return rulesSerializer.serialize(rulesProvider);
    } else if (rulesProvider is DefaultCompetitionRulesPreset) {
      return _serializePreset(rulesProvider);
    } else {
      throw UnsupportedError(
          'Unsupported CompetitionRulesProvider type: ${rulesProvider.runtimeType}');
    }
  }

  Json _serializePreset(DefaultCompetitionRulesPreset rulesPreset) {
    return {
      'type': 'fromPreset',
      'presetId': idsRepository.id(rulesPreset),
    };
  }
}
