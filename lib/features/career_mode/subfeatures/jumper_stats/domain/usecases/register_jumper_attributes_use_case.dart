import 'package:sj_manager/features/career_mode/subfeatures/current_date/domain/repository/simulation_current_date_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumper_stats/domain/entities/jumper_attribute.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumper_stats/domain/repository/jumper_stats_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_result.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class RegisterJumperAttributesUseCase {
  RegisterJumperAttributesUseCase({
    required this.statsRepository,
    required this.currentDateRepository,
  });

  final JumperStatsRepository statsRepository;
  final SimulationCurrentDateRepository currentDateRepository;

  Future<void> call({
    required SimulationJumper jumper,
    required JumperTrainingResult result,
  }) async {
    final currentDate = await currentDateRepository.get();
    Future<void> register(JumperAttributeType type, double value) async {
      jumper.stats.progressableAttributeHistory[type]!.register(value, date: currentDate);
    }

    await register(JumperAttributeType.takeoffQuality, jumper.takeoffQuality);
    await register(JumperAttributeType.flightQuality, jumper.flightQuality);
    await register(JumperAttributeType.landingQuality, jumper.landingQuality);
    await register(JumperAttributeType.form, jumper.form);
    await register(JumperAttributeType.consistency, jumper.jumpsConsistency);
    await register(JumperAttributeType.fatigue, jumper.fatigue);
  }
}
