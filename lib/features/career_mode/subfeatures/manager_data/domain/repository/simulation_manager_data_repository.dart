import 'package:sj_manager/features/simulations/domain/entities/simulation/database/manager_data/simulation_manager_data.dart';

abstract interface class SimulationManagerDataRepository {
  Future<SimulationManagerData> get();
  Future<void> set(SimulationManagerData managerData);
}
