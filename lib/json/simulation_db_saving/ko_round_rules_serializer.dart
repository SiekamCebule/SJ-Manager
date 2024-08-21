import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class KoRoundRulesSerializer implements SimulationDbPartSerializer<KoRoundRules> {
  const KoRoundRulesSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Json serialize(KoRoundRules rules) {
    return {
      'advancementDeterminatorId': idsRepo.idOf(rules.advancementDeterminator),
      'koGroupsCreatorId': idsRepo.idOf(rules.koGroupsCreator),
    };
  }
}
