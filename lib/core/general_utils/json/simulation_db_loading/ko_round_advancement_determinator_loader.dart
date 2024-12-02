import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/competition/rules/entities_limit.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/ko_round_advancement_determinator.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class KoRoundAdvancementDeterminatorLoader
    implements SimulationDbPartParser<KoRoundAdvancementDeterminator> {
  const KoRoundAdvancementDeterminatorLoader({
    required this.idsRepository,
    required this.entitiesLimitParser,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<EntitiesLimit> entitiesLimitParser;

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
