import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class KoRoundRulesSerializer implements SimulationDbPartSerializer<KoRoundRules> {
  const KoRoundRulesSerializer({
    required this.idsRepository,
    required this.advancementDeterminatorSerializer,
    required this.koGroupsCreatorSerializer,
  });

  final IdsRepository idsRepository;

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
