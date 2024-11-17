import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';
import 'package:sj_manager/features/game_variants/domain/repository/game_variants_repository.dart';

class SaveGameVariantUseCase {
  const SaveGameVariantUseCase({
    required this.gameVariantsRepository,
  });

  final GameVariantsRepository gameVariantsRepository;

  Future<void> call(GameVariant variant) async {
    await gameVariantsRepository.saveVariant(variant);
  }
}
