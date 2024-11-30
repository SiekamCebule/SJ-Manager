import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

abstract interface class SimDbSimulationJumpersDataSource {
  Iterable<SimulationJumper> getAll();
  void add(SimulationJumper jumper);
  void remove(SimulationJumper jumper);
}

class SimDbSimulationJumpersDataSourceImpl implements SimDbSimulationJumpersDataSource {
  SimDbSimulationJumpersDataSourceImpl({
    required this.database,
  });

  final SimulationDatabase database;

  @override
  Iterable<SimulationJumper> getAll() {
    return database.jumpers;
  }

  @override
  void add(SimulationJumper jumper) {
    database.jumpers = database.jumpers.toList()..add(jumper);
  }

  @override
  void remove(SimulationJumper jumper) {
    database.jumpers = database.jumpers.toList()..remove(jumper);
  }
}
