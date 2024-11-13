import 'package:sj_manager/commands/simulation_database/simulation_database_commander.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';

class SetUpTrainingsCommand {
  SetUpTrainingsCommand({
    required this.database,
    required this.onFinish,
  });

  final SimulationDatabase database;
  final Function()? onFinish;

  Future<void> execute() async {
    SimulationDatabaseCommander(
      database: database,
    ).setUpTrainings();
    onFinish?.call();
  }
}
