import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';

abstract interface class GameVariantsRepository {
  Future<void> loadAllVariants();
  Future<void> saveVariant(GameVariant variant);
  Future<List<GameVariant>> getAllVariants();
}
