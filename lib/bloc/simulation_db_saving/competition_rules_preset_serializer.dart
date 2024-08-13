import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class CompetitionRulesPresetSerializer
    implements SimulationDbPartSerializer<CompetitionRulesPreset> {
  const CompetitionRulesPresetSerializer({
    required this.idsRepo,
    required this.rulesSerializer,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartSerializer<CompetitionRules> rulesSerializer;

  @override
  Json serialize(CompetitionRulesPreset rulesPreset) {
    return {
      'name': rulesPreset.name,
      'rules': rulesSerializer.serialize(rulesPreset.rules),
    };
  }
}
