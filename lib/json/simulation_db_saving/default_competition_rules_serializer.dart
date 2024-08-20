import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

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
    if (rules is DefaultCompetitionRules<Jumper>) {
      return {
        'type': 'individual',
        'rounds': _serializeRounds(rules.rounds),
      };
    } else if (rules is DefaultCompetitionRules<Team>) {
      return {
        'type': 'team',
        'round': _serializeRounds(rules.rounds),
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
    return jsonList;
  }
}
