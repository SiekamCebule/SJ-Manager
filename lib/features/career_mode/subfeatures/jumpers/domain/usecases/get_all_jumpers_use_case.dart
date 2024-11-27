import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class GetAllJumpersUseCase {
  GetAllJumpersUseCase({
    required this.jumpersRepository,
  });

  final SimulationJumpersRepository jumpersRepository;

  Future<Iterable<SimulationJumper>> call() async {
    return await jumpersRepository.getAll();
  }
}
