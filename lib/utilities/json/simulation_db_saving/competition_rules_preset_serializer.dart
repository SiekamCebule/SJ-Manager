import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class CompetitionRulesPresetSerializer
    implements SimulationDbPartSerializer<DefaultCompetitionRulesPreset> {
  const CompetitionRulesPresetSerializer({
    required this.idsRepo,
    required this.rulesSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<DefaultCompetitionRules> rulesSerializer;

  @override
  Json serialize(DefaultCompetitionRulesPreset rulesPreset) {
    return {
      'name': rulesPreset.name,
      'rules': rulesSerializer.serialize(rulesPreset.rules),
    };
  }
}
