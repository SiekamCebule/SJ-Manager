import 'package:sj_manager/features/career_mode/subfeatures/current_date/domain/repository/simulation_current_date_repository.dart';

class SetSimulationCurrentDateUseCase {
  SetSimulationCurrentDateUseCase({
    required this.currentDateRepository,
  });

  final SimulationCurrentDateRepository currentDateRepository;

  Future<void> call(DateTime date) async {
    return await currentDateRepository.set(date);
  }
}
