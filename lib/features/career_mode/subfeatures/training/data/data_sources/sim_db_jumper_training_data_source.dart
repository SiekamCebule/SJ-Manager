import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_config.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

abstract interface class SimDbJumperTrainingDataSource {
  Future<JumperTrainingConfig> getTrainingConfig({
    required SimulationJumper jumper,
  });

  Future<void> setTrainingConfig({
    required SimulationJumper jumper,
    required JumperTrainingConfig trainingConfig,
  });
}

class SimDbJumperTrainingDataSourceImpl implements SimDbJumperTrainingDataSource {
  SimDbJumperTrainingDataSourceImpl({
    required this.database,
  });

  final SimulationDatabase database;

  @override
  Future<JumperTrainingConfig> getTrainingConfig({
    required SimulationJumper jumper,
  }) async {
    return jumper.trainingConfig!;
  }

  @override
  Future<void> setTrainingConfig({
    required SimulationJumper jumper,
    required JumperTrainingConfig trainingConfig,
  }) async {
    jumper.trainingConfig = trainingConfig;
  }
}
