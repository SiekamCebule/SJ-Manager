import 'package:sj_manager/features/game_variants/data/models/game_variant_model.dart';

abstract interface class GameVariantModelsDataSource {
  Future<List<GameVariantModel>> getAllVariants();
  Future<void> saveAllVariants(List<GameVariantModel> models);
}

class GameVariantModelsLocalDataSource implements GameVariantModelsDataSource {
  @override
  Future<List<GameVariantModel>> getAllVariants() {
    throw UnimplementedError(); // TODO
  }

  @override
  Future<void> saveAllVariants(List<GameVariantModel> models) {
    // TODO: implement saveAllVariants
    throw UnimplementedError();
  }
}
