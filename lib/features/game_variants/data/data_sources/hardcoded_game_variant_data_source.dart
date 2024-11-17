import 'package:sj_manager/features/game_variants/data/models/game_variant_model.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';

abstract interface class HardcodedGameVariantDataSource {
  Future<GameVariant> fromModel(GameVariantModel model);
}
