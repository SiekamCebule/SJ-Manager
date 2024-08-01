import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class CompetitionRulesLoader implements SimulationDbPartLoader<CompetitionRules> {
  const CompetitionRulesLoader({
    required this.idsRepo,
    required this.roundRulesLoader,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartLoader<CompetitionRoundRules> roundRulesLoader;

  @override
  CompetitionRules load(Json json) {
    final type = json['type'] as String;
    if (type == 'raw') {
      return _loadRaw(json);
    } else if (type == 'fromPreset') {
      return _loadFromPreset(json);
    } else {
      throw ArgumentError(
        'Invalid competition rules type: $type (It can be only \'raw\' and \'fromPreset\')',
      );
    }
  }

  CompetitionRules _loadRaw(Json json) {
    final roundsJson = json['rounds'] as List<Json>;
    final rounds = roundsJson.map((json) {
      return roundRulesLoader.load(json);
    }).toList();
    return CompetitionRules(rounds: rounds);
  }

  CompetitionRules _loadFromPreset(Json json) {
    final presetId = json['presetId'] as String;
    final preset = idsRepo.get<CompetitionRules>(presetId); // TODO: Competition preset
    return preset;
  }
}
