import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class GetAllMaleJumpersUseCase {
  GetAllMaleJumpersUseCase({
    required this.jumpersRepository,
  });

  final SimulationJumpersRepository jumpersRepository;

  Future<Iterable<SimulationMaleJumper>> call() async {
    final jumpers = await jumpersRepository.getAll();
    return jumpers.whereType<SimulationMaleJumper>();
  }
}
