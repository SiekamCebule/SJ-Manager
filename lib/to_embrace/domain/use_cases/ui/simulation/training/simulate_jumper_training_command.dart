import 'package:sj_manager/to_embrace/domain/use_cases/simulation_database_use_cases.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/core/career_mode/career_mode_utils/training/training_engine/jumper_training_engine.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class SimulateJumperTrainingCommand {
  SimulateJumperTrainingCommand({
    required this.database,
    required this.jumper,
  });

  final SimulationDatabase database;
  final SimulationJumper jumper;

  void execute() {
    if (jumper.trainingConfig == null) {
      throw StateError(
        'Cannot simulate the training for particular jumper ($jumper) because it did not get the training configurated',
      );
    }
    final trainingResult = JumperTrainingEngine(
      jumper: jumper,
    ).doTraining();

    SimulationDatabaseUseCases(database: database).registerJumperTraining(
      jumper: jumper,
      result: trainingResult,
      date: database.currentDate,
    );
  }
}
