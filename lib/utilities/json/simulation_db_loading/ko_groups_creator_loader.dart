import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_classic.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_random.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/ko_group_creator.dart/concrete/default_with_pots.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class KoGroupsCreatorLoader implements SimulationDbPartParser<KoGroupsCreator> {
  const KoGroupsCreatorLoader({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  KoGroupsCreator parse(Json json) {
    final type = json['type'] as String;
    return switch (type) {
      'default_classic' => DefaultClassicKoGroupsCreator(),
      'default_random' => DefaultRandomKoGroupsCreator(),
      'default_pots' => DefaultPotsKoGroupsCreator(),
      _ => throw UnsupportedError(
          '(Loading) An unsupported KoGroupsCreator type ($type)',
        ),
    };
  }
}
