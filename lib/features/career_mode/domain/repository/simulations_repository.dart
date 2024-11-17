import 'package:sj_manager/features/career_mode/domain/entities/simulation.dart';

abstract interface class SimulationsRepository {
  Future<List<Simulation>> getAll();
  Future<void> add(Simulation simulation);
  Future<void> remove(Simulation simulation);
}
