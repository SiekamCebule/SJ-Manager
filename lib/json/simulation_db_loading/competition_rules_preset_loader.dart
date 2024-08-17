import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class CompetitionRulesPresetLoader
    implements SimulationDbPartLoader<CompetitionRulesPreset> {
  const CompetitionRulesPresetLoader({
    required this.idsRepo,
    required this.rulesLoader,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartLoader<CompetitionRules> rulesLoader;

  @override
  CompetitionRulesPreset load(Json json) {
    return CompetitionRulesPreset(
      name: json['name'],
      rules: rulesLoader.load(json['rules']),
    );
  }
}
