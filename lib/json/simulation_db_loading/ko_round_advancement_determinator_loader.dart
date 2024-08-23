import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class KoRoundAdvancementDeterminatorLoader
    implements SimulationDbPartParser<KoRoundAdvancementDeterminator> {
  const KoRoundAdvancementDeterminatorLoader({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  KoRoundAdvancementDeterminator parse(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'n_best' => const NBestKoRoundAdvancementDeterminator(),
      _ => throw UnsupportedError(
          '(Loading) An unsupported KoRoundAdvancementDeterminator type ($type)',
        ),
    };
  }
}
