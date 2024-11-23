import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/training/simulate_jumper_training_command.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

class SimulateGlobalTrainingCommand {
  SimulateGlobalTrainingCommand({
    required this.database,
  });

  final SimulationDatabase database;

  void execute() {
    var database = this.database;
    final jumpers = database.jumpers;
    for (var jumper in jumpers) {
      SimulateJumperTrainingCommand(
        database: database,
        jumper: jumper,
      ).execute();
    }
  }
}
