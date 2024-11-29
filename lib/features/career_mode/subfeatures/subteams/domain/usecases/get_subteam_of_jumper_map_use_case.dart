import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class GetSubteamOfJumperMapUseCase {
  const GetSubteamOfJumperMapUseCase({
    required this.jumpersRepository,
  });

  final SimulationJumpersRepository jumpersRepository;

  Future<Map<SimulationJumper, Subteam>> call() async {
    final jumpers = await jumpersRepository.getAll();
    return {
      for (final jumper in jumpers)
        if (jumper.subteam != null) jumper: jumper.subteam!,
    };
  }
}
