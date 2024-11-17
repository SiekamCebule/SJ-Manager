import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/features/game_variants/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/domain/entities/simulation/team/competition_team.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class DefaultCompetitionRulesSerializer
    implements SimulationDbPartSerializer<DefaultCompetitionRules> {
  const DefaultCompetitionRulesSerializer({
    required this.idsRepo,
    required this.roundRulesSerializer,
  });

  final ItemsIdsRepo idsRepo;
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
