import 'package:sj_manager/domain/use_cases/simulation_database_use_cases.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/utilities/algorithms/training_engine/jumper_training_engine.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/simulation_jumper.dart';

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
