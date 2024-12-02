import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/entities_limit.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class KoRoundAdvancementDeterminatorSerializer
    implements SimulationDbPartSerializer<KoRoundAdvancementDeterminator> {
  const KoRoundAdvancementDeterminatorSerializer({
    required this.idsRepository,
    required this.entitiesLimitSerializer,
  });

  final IdsRepository idsRepository;
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
