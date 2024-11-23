import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/features/database_editor/domain/repository/database_editor_items_repository.dart';
import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';
import 'package:sj_manager/features/game_variants/domain/repository/game_variants_repository.dart';

class ConstructEditedGameVariantUseCase {
  const ConstructEditedGameVariantUseCase({
    required this.maleJumperRepository,
    required this.femaleJumperRepository,
    required this.gameVariantsRepository,
    required this.gameVariantId,
  });

  final DatabaseEditorItemsRepository<MaleJumperDbRecord> maleJumperRepository;
  final DatabaseEditorItemsRepository<FemaleJumperDbRecord> femaleJumperRepository;
  final GameVariantsRepository gameVariantsRepository;
  final String gameVariantId;

  Future<GameVariant> call() async {
    final currentGameVariant = await gameVariantsRepository.getVariant(gameVariantId);
    return currentGameVariant.copyWith(jumpers: [
      ...await maleJumperRepository.getAll(),
      ...await femaleJumperRepository.getAll(),
    ]);
  }
}
