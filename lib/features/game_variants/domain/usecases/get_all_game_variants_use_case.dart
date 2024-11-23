import 'package:sj_manager/features/game_variants/domain/entities/game_variant.dart';
import 'package:sj_manager/features/game_variants/domain/repository/game_variants_repository.dart';

class GetAllGameVariantsUseCase {
  const GetAllGameVariantsUseCase({
    required this.gameVariantsRepository,
  });

  final GameVariantsRepository gameVariantsRepository;

  Future<List<GameVariant>> call() async {
    return await gameVariantsRepository.getAllVariants();
  }
}
