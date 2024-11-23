import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class CompetitionRulesPresetSerializer
    implements SimulationDbPartSerializer<DefaultCompetitionRulesPreset> {
  const CompetitionRulesPresetSerializer({
    required this.idsRepository,
    required this.rulesSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<DefaultCompetitionRules> rulesSerializer;

  @override
  Json serialize(DefaultCompetitionRulesPreset rulesPreset) {
    return {
      'name': rulesPreset.name,
      'rules': rulesSerializer.serialize(rulesPreset.rules),
    };
  }
}
