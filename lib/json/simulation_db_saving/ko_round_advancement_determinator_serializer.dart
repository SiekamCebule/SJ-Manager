import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class KoRoundAdvancementDeterminatorSerializer
    implements SimulationDbPartSerializer<KoRoundAdvancementDeterminator> {
  const KoRoundAdvancementDeterminatorSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Json serialize(KoRoundAdvancementDeterminator determinator) {
    if (determinator is KoRoundNBestAdvancementDeterminingContext) {
      return _parseNBest(determinator);
    } else {
      throw UnsupportedError(
        '(Parsing) An unsupported KoRoundAdvancementDeterminatorSerializer type (${determinator.runtimeType})',
      );
    }
  }

  Json _parseNBest(KoRoundAdvancementDeterminator determinator) {
    return {
      'type': 'n_best',
    };
  }
}
