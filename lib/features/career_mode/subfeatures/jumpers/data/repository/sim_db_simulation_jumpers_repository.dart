import 'package:sj_manager/features/career_mode/subfeatures/jumpers/data/data_sources/sim_db_simulation_jumpers_data_source.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class SimDbSimulationJumpersRepository implements SimulationJumpersRepository {
  SimDbSimulationJumpersRepository({required this.dataSource});

  final SimDbSimulationJumpersDataSource dataSource;

  @override
  Future<Iterable<SimulationJumper>> getAll() async {
    return dataSource.getAll();
  }

  @override
  Future<void> add(SimulationJumper jumper) async {
    dataSource.add(jumper);
  }

  @override
  Future<void> remove(SimulationJumper jumper) async {
    dataSource.remove(jumper);
  }
}
