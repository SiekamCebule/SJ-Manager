import 'package:sj_manager/domain/use_cases/simulation_database_use_cases.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';

class SetUpTrainingsCommand {
  SetUpTrainingsCommand({
    required this.database,
    required this.onFinish,
  });

  final SimulationDatabase database;
  final Function()? onFinish;

  Future<void> execute() async {
    SimulationDatabaseUseCases(
      database: database,
    ).setUpTrainings();
    onFinish?.call();
  }
}
