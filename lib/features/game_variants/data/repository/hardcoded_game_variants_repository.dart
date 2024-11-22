import 'package:sj_manager/features/game_variants/data/convert/game_variants_converting.dart';
import 'package:sj_manager/features/game_variants/data/convert/hardcoded_variants.dart';
import 'package:sj_manager/features/game_variants/data/data_sources/local_game_variants_data_source.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_model.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';
import 'package:sj_manager/features/game_variants/domain/repository/game_variants_repository.dart';

class HardcodedGameVariantsRepository implements GameVariantsRepository {
  HardcodedGameVariantsRepository({
    required this.dataSource,
  });

  final LocalGameVariantsDataSource dataSource;

  Map<String, GameVariant> _cache = {};

  @override
  Future<void> loadAllVariants() async {
    final models = await dataSource.loadAllVariants();
    Future<GameVariant> fromModel(GameVariantModel model) async {
      return await sjmHardcodedGameVariantDataSources[model.id]!.fromModel(model);
    }

    _cache = {
      for (final model in models) model.id: await fromModel(model),
    };
  }

  @override
  Future<void> saveVariant(GameVariant variant) async {
    await dataSource.saveAllVariants([variant.toModel()]);
  }

  @override
  Future<List<GameVariant>> getAllVariants() async {
    if (_cache.isEmpty) {
      await loadAllVariants();
    }
    return _cache.values.toList();
  }
}
