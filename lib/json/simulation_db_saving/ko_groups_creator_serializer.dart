import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_random.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_with_pots.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class KoGroupsCreatorSerializer implements SimulationDbPartSerializer<KoGroupsCreator> {
  const KoGroupsCreatorSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Json serialize(KoGroupsCreator creator) {
    if (creator is DefaultClassicKoGroupsCreator) {
      return _parseDefaultClassic(creator);
    } else if (creator is DefaultRandomKoGroupsCreator) {
      return _parseDefaultRandom(creator);
    } else if (creator is DefaultPotsKoGroupsCreator) {
      return _parseDefaultPots(creator);
    } else {
      throw UnsupportedError(
        '(Parsing) An unsupported KoGroupsCreator type (${creator.runtimeType})',
      );
    }
  }

  Json _parseDefaultClassic(DefaultClassicKoGroupsCreator averager) {
    return {
      'type': 'default_classic',
    };
  }

  Json _parseDefaultRandom(DefaultRandomKoGroupsCreator averager) {
    return {
      'type': 'default_random',
    };
  }

  Json _parseDefaultPots(DefaultPotsKoGroupsCreator averager) {
    return {
      'type': 'default_pots',
    };
  }
}
