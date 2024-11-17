import 'package:sj_manager/features/game_variants/domain/repository/game_variants_repository.dart';

class ConstructGameVariantsUseCase {
  const ConstructGameVariantsUseCase({
    required this.gameVariantsRepository,
  });

  final GameVariantsRepository gameVariantsRepository;

  Future<void> call() async {
    await gameVariantsRepository.loadAllVariants();
  }
}
