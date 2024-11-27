import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

abstract interface class SimulationJumpersRepository {
  Future<Iterable<SimulationJumper>> getAll();
  Future<void> add(SimulationJumper jumper);
  Future<void> remove(SimulationJumper jumper);
}
