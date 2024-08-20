import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class CompetitionRulesPresetLoader
    implements SimulationDbPartLoader<DefaultCompetitionRulesPreset> {
  const CompetitionRulesPresetLoader({
    required this.idsRepo,
    required this.rulesLoader,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartLoader<DefaultCompetitionRules> rulesLoader;

  @override
  DefaultCompetitionRulesPreset load(Json json) {
    return DefaultCompetitionRulesPreset(
      name: json['name'],
      rules: rulesLoader.load(json['rules']),
    );
  }
}
