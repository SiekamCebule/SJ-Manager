import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';

abstract interface class SimulationsRepository {
  Future<List<SjmSimulation>> getAll();
  Future<SjmSimulation> get(String id);

  Future<void> loadAll();

  Future<void> add(
    SjmSimulation simulation, {
    required DateTime saveTime,
    required SimulationMode mode,
  });
  Future<void> remove(String simulationId);

  Future<void> preserve(
    SjmSimulation simulation, {
    required DateTime saveTime,
    required SimulationMode mode,
  });

  Future<Stream<List<SjmSimulation>>> get stream;
}
