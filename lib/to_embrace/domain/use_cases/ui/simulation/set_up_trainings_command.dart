import 'package:sj_manager/to_embrace/domain/use_cases/simulation_database_use_cases.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

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
