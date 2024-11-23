import 'package:sj_manager/core/general_utils/iterable.dart';
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
  Future<List<GameVariant>> getAllVariants() async {
    if (_cache.isEmpty) {
      await loadAllVariants();
    }
    final variants =
        _cache.keys.asyncMap((variantId) async => await getVariant(variantId));
    return (await variants).toList();
  }

  @override
  Future<GameVariant> getVariant(String variantId) async {
    return _cache[variantId] ?? await loadVariant(variantId);
  }

  @override
  Future<void> loadAllVariants() async {
    final models = await dataSource.loadAllVariantModels();
    Future<GameVariant> fromModel(GameVariantModel model) async {
      return loadVariant(model.id);
    }

    _cache = {
      for (final model in models) model.id: await fromModel(model),
    };
  }

  @override
  Future<GameVariant> loadVariant(String variantId) async {
    final model = await dataSource.loadVariantModel(gameVariantId: variantId);
    return await sjmHardcodedGameVariantDataSources[model.id]!.fromModel(model);
  }

  @override
  Future<void> saveVariant(GameVariant variant) async {
    await dataSource.saveVariantModel(variant.toModel());
  }
}
