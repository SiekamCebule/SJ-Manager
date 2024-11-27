import 'package:sj_manager/features/career_mode/subfeatures/current_date/data/data_sources/sim_db_simulation_current_date_data_source.dart';
import 'package:sj_manager/features/career_mode/subfeatures/current_date/domain/repository/simulation_current_date_repository.dart';

class SimDbSimulationCurrentDateRepository implements SimulationCurrentDateRepository {
  SimDbSimulationCurrentDateRepository({
    required this.dataSource,
  });

  final SimDbSimulationCurrentDateDataSource dataSource;

  @override
  Future<DateTime> get() async {
    return await dataSource.get();
  }

  @override
  Future<void> set(DateTime date) async {
    await dataSource.set(date);
  }
}
