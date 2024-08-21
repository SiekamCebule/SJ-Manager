import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class KoRoundRulesLoader implements SimulationDbPartLoader<KoRoundRules> {
  const KoRoundRulesLoader({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  KoRoundRules load(Json json) {
    return KoRoundRules(
      advancementDeterminator: idsRepo.get(json['advancementDeterminatorId']),
      koGroupsCreator: idsRepo.get(json['koGroupsCreatorId']),
    );
  }
}
