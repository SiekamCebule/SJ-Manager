import 'package:sj_manager/features/career_mode/subfeatures/config/domain/repository/simulation_config_repository.dart';

class GetTraineesLimitForPersonalCoachUseCase {
  const GetTraineesLimitForPersonalCoachUseCase({
    required this.configRepository,
  });

  final SimulationConfigRepository configRepository;

  Future<int> call() async {
    return configRepository.getTraineesLimitForPersonalCoach();
  }
}
