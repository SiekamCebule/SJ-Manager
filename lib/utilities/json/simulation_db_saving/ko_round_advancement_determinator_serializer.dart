import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/entities_limit.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class KoRoundAdvancementDeterminatorSerializer
    implements SimulationDbPartSerializer<KoRoundAdvancementDeterminator> {
  const KoRoundAdvancementDeterminatorSerializer({
    required this.idsRepo,
    required this.entitiesLimitSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<EntitiesLimit> entitiesLimitSerializer;

  @override
  Json serialize(KoRoundAdvancementDeterminator determinator) {
    if (determinator is NBestKoRoundAdvancementDeterminator) {
      return {'type': 'n_best'};
    } else {
      throw UnsupportedError(
        '(Parsing) An unsupported KoRoundAdvancementDeterminatorSerializer type (${determinator.runtimeType})',
      );
    }
  }
}
