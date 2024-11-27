import 'package:sj_manager/features/career_mode/subfeatures/current_date/domain/repository/simulation_current_date_repository.dart';

class GetSimulationCurrentDateUseCase {
  GetSimulationCurrentDateUseCase({
    required this.currentDateRepository,
  });

  final SimulationCurrentDateRepository currentDateRepository;

  Future<DateTime> call() async {
    return await currentDateRepository.get();
  }
}
