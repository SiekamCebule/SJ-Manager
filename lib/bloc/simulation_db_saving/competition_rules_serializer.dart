import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class CompetitionRulesSerializer implements SimulationDbPartSerializer<CompetitionRules> {
  const CompetitionRulesSerializer({
    required this.idsRepo,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartSerializer<CompetitionRoundRules> roundRulesSerializer;

  @override
  Json serialize(CompetitionRules rules) {
    // TODO: how to differ the preset rules and raw rules?
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

  Json _serializePreset(CompetitionRules rules) {
    return {
      'type': 'fromPreset',
      'presetId': idsRepo.idOf(rules), // TODO: ???
    };
  }
}
