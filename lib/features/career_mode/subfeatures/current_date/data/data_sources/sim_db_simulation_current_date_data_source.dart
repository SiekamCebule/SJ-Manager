import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

abstract interface class SimDbSimulationCurrentDateDataSource {
  Future<DateTime> get();
  Future<void> set(DateTime date);
}

class SimDbSimulationCurrentDateDataSourceImpl
    implements SimDbSimulationCurrentDateDataSource {
  SimDbSimulationCurrentDateDataSourceImpl({
    required this.database,
  });

  final SimulationDatabase database;

  @override
  Future<DateTime> get() async {
    return database.currentDate;
  }

  @override
  Future<void> set(DateTime date) async {
    database.currentDate = date;
  }
}
