import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class KoRoundRulesSerializer implements SimulationDbPartSerializer<KoRoundRules> {
  const KoRoundRulesSerializer({
    required this.idsRepo,
    required this.advancementDeterminatorSerializer,
    required this.koGroupsCreatorSerializer,
  });

  final ItemsIdsRepo idsRepo;

  final SimulationDbPartSerializer<KoRoundAdvancementDeterminator>
      advancementDeterminatorSerializer;
  final SimulationDbPartSerializer<KoGroupsCreator> koGroupsCreatorSerializer;

  @override
  Json serialize(KoRoundRules rules) {
    return {
      'advancementDeterminator':
          advancementDeterminatorSerializer.serialize(rules.advancementDeterminator),
      'koGroupsCreator': koGroupsCreatorSerializer.serialize(rules.koGroupsCreator),
    };
  }
}
