import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

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
      'advancementCount': rules.advancementCount,
      'koGroupsCreator': koGroupsCreatorSerializer.serialize(rules.koGroupsCreator),
      'groupSize': rules.groupSize,
    };
  }
}
