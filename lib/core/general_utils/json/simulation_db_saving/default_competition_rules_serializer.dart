import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/competition_team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class DefaultCompetitionRulesSerializer
    implements SimulationDbPartSerializer<DefaultCompetitionRules> {
  const DefaultCompetitionRulesSerializer({
    required this.idsRepository,
    required this.roundRulesSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<DefaultCompetitionRoundRules> roundRulesSerializer;

  @override
  Json serialize(DefaultCompetitionRules rules) {
    if (rules is DefaultCompetitionRules<JumperDbRecord>) {
      return {
        'type': 'individual',
        'rounds': _serializeRounds(rules.rounds),
      };
    } else if (rules is DefaultCompetitionRules<CompetitionTeam>) {
      return {
        'type': 'team',
        'rounds': _serializeRounds(rules.rounds),
      };
    } else {
      throw UnsupportedError(
        'The serializer does not support default competition rules of type ${rules.runtimeType}',
      );
    }
  }

  List<Json> _serializeRounds(List<DefaultCompetitionRoundRules> roundRulesList) {
    final jsonList = roundRulesList.map((roundRules) {
      return roundRulesSerializer.serialize(roundRules);
    }).toList();
    return jsonList.cast();
  }
}
