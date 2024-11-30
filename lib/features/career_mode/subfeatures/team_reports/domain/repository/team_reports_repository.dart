import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/team_reports.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

abstract interface class TeamReportsRepository {
  Future<TeamReports?> get(SimulationTeam team);
  Future<void> set({
    required SimulationTeam team,
    required TeamReports? reports,
  });
}
